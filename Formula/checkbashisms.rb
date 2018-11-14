class Checkbashisms < Formula
  desc "Checks for bashisms in shell scripts"
  homepage "https://launchpad.net/ubuntu/+source/devscripts/"
  url "https://deb.debian.org/debian/pool/main/d/devscripts/devscripts_2.18.9.tar.xz"
  sha256 "75027f6fbbbc9a9ab1b2bb7b8651622fbd9d3d691e8f4a21639865c9efe4b0e4"

  bottle :unneeded

  def install
    inreplace "scripts/checkbashisms.pl" do |s|
      s.gsub! "###VERSION###", version
      s.gsub! "#!/usr/bin/perl", "#!/usr/bin/perl -T"
    end

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
