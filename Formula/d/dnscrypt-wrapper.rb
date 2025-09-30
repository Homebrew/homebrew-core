class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/cofyc/dnscrypt-wrapper/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "911856dc4e211f906ca798fcf84f5b62be7fdbf73c53e5715ce18d553814ac86"
  license "ISC"
  revision 2
  head "https://github.com/Cofyc/dnscrypt-wrapper.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "155ae1204059e3966a89fc6a1da59af00637662f7cb96e2d7a37a7439676a659"
    sha256 cellar: :any,                 arm64_sequoia: "c044e99092e598b8ae1ea0415864f0f8220949113fdc23e79ac9182ac9932ef9"
    sha256 cellar: :any,                 arm64_sonoma:  "a031227485010c215196c1cdd275763f4e99fb7a6cb4c312008e1700beb2c70e"
    sha256 cellar: :any,                 sonoma:        "bc437509b36ffd78cb7e5f560ae00ebcefe8c63790ce6cebe11e739d985a1729"
    sha256 cellar: :any,                 ventura:       "1aeb1619be4bfddebbe11aae4cd7763e045e76f7002426291c2b3d41b2d4db68"
    sha256 cellar: :any,                 monterey:      "5ef765f7940b89b56f2fe21d5d540c1dc35f4c710292bd046b172b405b2f0814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bab5cbaa538d70c74a6f741af979309edac5bcd368abb34e2d41cbe4280d14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfaec9e6087a736aabf33b3a638e6133e7da8fc76700d2404bd29e5b33ec5380"
  end

  depends_on "autoconf" => :build
  depends_on "libevent"
  depends_on "libsodium"

  def install
    # Workaround for arm64 macOS, https://github.com/cofyc/dnscrypt-wrapper/issues/177
    inreplace "compat.h", "#define HAVE_BACKTRACE 1", "" if OS.mac? && Hardware::CPU.arm?

    system "make", "configure"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system sbin/"dnscrypt-wrapper", "--gen-provider-keypair",
                                    "--provider-name=2.dnscrypt-cert.example.com",
                                    "--ext-address=192.168.1.1"
    system sbin/"dnscrypt-wrapper", "--gen-crypt-keypair"
  end
end
