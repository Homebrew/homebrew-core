class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/cofyc/dnscrypt-wrapper/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "911856dc4e211f906ca798fcf84f5b62be7fdbf73c53e5715ce18d553814ac86"
  license "ISC"
  revision 2
  head "https://github.com/Cofyc/dnscrypt-wrapper.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 sonoma:       "bc437509b36ffd78cb7e5f560ae00ebcefe8c63790ce6cebe11e739d985a1729"
    sha256 cellar: :any,                 ventura:      "1aeb1619be4bfddebbe11aae4cd7763e045e76f7002426291c2b3d41b2d4db68"
    sha256 cellar: :any,                 monterey:     "5ef765f7940b89b56f2fe21d5d540c1dc35f4c710292bd046b172b405b2f0814"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dfaec9e6087a736aabf33b3a638e6133e7da8fc76700d2404bd29e5b33ec5380"
  end

  depends_on "autoconf" => :build
  depends_on "libevent"
  depends_on "libsodium"

  on_macos do
    depends_on arch: :x86_64 # https://github.com/cofyc/dnscrypt-wrapper/issues/177
  end

  def install
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
