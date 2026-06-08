class Checkbashisms < Formula
  desc "Checks for bashisms in shell scripts"
  homepage "https://launchpad.net/ubuntu/+source/devscripts/"
  url "https://deb.debian.org/debian/pool/main/d/devscripts/devscripts_2.26.9.tar.xz"
  sha256 "61429335d33a3e744966185bda49e7a354705c0e59600f17d50c1e656d39066e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/d/devscripts/"
    regex(/href=.*?devscripts[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "59ddea0036642f32e56912b93e77ce497efec3e4a6687a19995c7f14f6492aee"
  end

  def install
    inreplace "scripts/checkbashisms.pl" do |s|
      s.gsub! "###VERSION###", version.to_s
      s.gsub! "#!/usr/bin/perl", "#!/usr/bin/perl -T"
    end

    bin.install "scripts/checkbashisms.pl" => "checkbashisms"
    man1.install "scripts/checkbashisms.1"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      #!/bin/sh

      if [[ "home == brew" ]]; then
        echo "dog"
      fi
    SHELL
    expected = <<~EOS
      (alternative test command ([[ foo ]] should be [ foo ])):
    EOS
    assert_match expected, shell_output("#{bin}/checkbashisms #{testpath}/test.sh 2>&1", 1)
  end
end
