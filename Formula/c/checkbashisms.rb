class Checkbashisms < Formula
  desc "Checks for bashisms in shell scripts"
  homepage "https://launchpad.net/ubuntu/+source/devscripts/"
  url "https://deb.debian.org/debian/pool/main/d/devscripts/devscripts_2.26.17.tar.xz"
  sha256 "a4a3d68d8950df21024238fcfe1f71342c7cb96d1de6f7e10595e94be83d066e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/d/devscripts/"
    regex(/href=.*?devscripts[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "dae445af1317692ee552a4e7ffc5dac93910109cf97a10d3e6974ddd7dba39f0"
    sha256 cellar: :any_skip_relocation, all: "6ac82d1e25e4fa00f5ffebf6fc7df0a6d1160b68ec927798328cbe2faee76102"
  end

  deny_network_access!

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
