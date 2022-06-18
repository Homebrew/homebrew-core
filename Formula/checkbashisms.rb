class Checkbashisms < Formula
  desc "Checks for bashisms in shell scripts"
  homepage "https://launchpad.net/ubuntu/+source/devscripts/"
  url "https://deb.debian.org/debian/pool/main/d/devscripts/devscripts_2.22.2.tar.xz"
  sha256 "15f95a96dd89c6a2d2d20ab4c32f3ca570aa88dbc78fbb1f3fb7cbc1d4a6502b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/d/devscripts/"
    regex(/href=.*?devscripts[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd4c1264761f3e9d8cc16032058a212ba83fc0ba5f8d5a98fc0ece0dd52287b5"
  end

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
