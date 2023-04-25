class Libnatpmp < Formula
  desc "NAT port mapping protocol library"
  homepage "http://miniupnp.free.fr/libnatpmp.html"
  url "http://miniupnp.free.fr/files/download.php?file=libnatpmp-20230423.tar.gz"
  sha256 "0684ed2c8406437e7519a1bd20ea83780db871b3a3a5d752311ba3e889dbfc70"
  license "BSD-3-Clause"

  livecheck do
    url "http://miniupnp.free.fr/files/"
    regex(/href=.*?libnatpmp[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5cbc86e7961c27660615db095ed871533441d5fe6d25b603207175c055ae2f63"
    sha256 cellar: :any,                 arm64_monterey: "ee662cfd4f0cd0c0b2e4e41d4b78dc6b869a2a9b879b99b2bbd2f9c95449817e"
    sha256 cellar: :any,                 arm64_big_sur:  "e1dc94e564f2390fabcffb750cd4b0a8a3f25679dc8d960cce9387668b25f6ab"
    sha256 cellar: :any,                 ventura:        "bd45f955745ed2788cd2515f882162846bdce682b95010b070e22335157c2819"
    sha256 cellar: :any,                 monterey:       "a2d116b11fd0e979c2af60c047b962f272118a955057c223c6e26bbd861edea5"
    sha256 cellar: :any,                 big_sur:        "df74dfd28a0c684d13de2dcd3d655c424210eb89b6c42f81c371ad0a356b27fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71a7aca17fef233ad343105dc86f13bf2d1ad39514cc7ea5c9890f5c7b52baa1"
  end

  def install
    # Reported upstream:
    # https://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace "Makefile", "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    # Use a non-existent gateway.
    output = shell_output("#{bin}/natpmpc -g 0.0.0.0 2>&1", 1)
    [
      "initnatpmp() returned 0 (SUCCESS)",
      "sendpublicaddressrequest returned 2 (SUCCESS)",
      "readnatpmpresponseorretry() failed : the gateway does not support nat-pmp",
    ].each do |expected_match|
      assert_match expected_match, output
    end
  end
end
