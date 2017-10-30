class Checkbashisms < Formula
  desc "Checks for bashisms in shell scripts"
  homepage "https://launchpad.net/ubuntu/+source/devscripts/"
  url "https://launchpad.net/ubuntu/+archive/primary/+files/devscripts_2.17.9build1.tar.xz"
  version "2.17.9build1"
  sha256 "e0cb232c37eaf8a18584637b1170875b21a632bbd8a3aca2a83499e18beee0dd"

  head "lp:ubuntu/devscripts", :using => :bzr

  bottle :unneeded

  def install
    inreplace "scripts/checkbashisms.pl", "###VERSION###", version
    bin.install "scripts/checkbashisms.pl" => "checkbashisms"
    man1.install "scripts/checkbashisms.1"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/sh

      if [[ "home == brew" ]]; then
        echo "dog"
      fi
    EOS
    expected = <<~EOS
      (alternative test command ([[ foo ]] should be [ foo ])):
    EOS
    assert_match expected, shell_output("#{bin}/checkbashisms #{testpath}/test.sh 2>&1", 1)
  end
end
