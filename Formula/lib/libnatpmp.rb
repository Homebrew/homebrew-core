class Libnatpmp < Formula
  desc "NAT port mapping protocol library"
  homepage "https://miniupnp.tuxfamily.org/libnatpmp.html"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=libnatpmp-20230423.tar.gz"
  sha256 "0684ed2c8406437e7519a1bd20ea83780db871b3a3a5d752311ba3e889dbfc70"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?libnatpmp[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "2b116cdd78f36020d0fb816671973f6ad2ec880647e2bff2915d7645ec4b0ce7"
    sha256 cellar: :any, arm64_tahoe:       "4398ea5d9d517fdcfe67a1e14364423156cdb6e5b4b38c3402f040de145ca363"
    sha256 cellar: :any, arm64_sequoia:     "a3613d14e472288a40a3c5bbc3727b815fee73976d6fca7d519b3ea49dcb2406"
    sha256 cellar: :any, arm64_linux:       "513fe13811b08989129129b2cc3410b8adb0a84579f4e592c3754de9238afd6b"
    sha256 cellar: :any, x86_64_linux:      "bdf43166795722ebd9cbe7c58e82ff348ce1bfaaee34f0cb812421a65b13ac26"
  end

  # Fix missing header. Remove when no longer applicable.
  patch do
    url "https://github.com/miniupnp/libnatpmp/commit/5f4a7c65837a56e62c133db33c28cd1ea71db662.patch?full_index=1"
    sha256 "4643048d7e24f8aed4e11e572f3e22f79eae97bb289ae1bbf103b84e8e32f61a"
    type :backport
    resolves "https://github.com/miniupnp/libnatpmp/pull/22"
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
