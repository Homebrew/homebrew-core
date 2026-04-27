class Hashcash < Formula
  desc "Proof-of-work algorithm to counter denial-of-service (DoS) attacks"
  homepage "http://hashcash.org"
  url "https://deb.debian.org/debian/pool/main/h/hashcash/hashcash_1.22.orig.tar.gz"
  mirror "http://hashcash.org/source/hashcash-1.22.tgz"
  sha256 "0192f12d41ce4848e60384398c5ff83579b55710601c7bffe6c88bc56b547896"
  license any_of: [:public_domain, "BSD-3-Clause", "LGPL-2.1-only", "GPL-2.0-only"]
  revision 2

  livecheck do
    url "http://hashcash.org/source/"
    regex(/href=.*?hashcash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26f68ae8588611b8c34206972c00c1d064151c7f2a49134ad4f51e33bda89d2c"
    sha256 cellar: :any,                 arm64_sequoia: "38e173f8538d6024cfe2563dade3b6088f9fcc3bd224ee0b9851a1c16c7ab026"
    sha256 cellar: :any,                 arm64_sonoma:  "7eef3120392caf2bffaa68aacde203c1b8fc06df1fe795917213cd074d5397af"
    sha256 cellar: :any,                 sonoma:        "2f317c1fe7c06050988c8898c9b1cb3daf700a50611f1da45a4eaada9869f34c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5253ec337945555c6a121f3507099fd086c7bfe55f31f032160861f333a7ed36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26fb6683864840f1f870313f11176487bdea14a4c679af44bf215efc32034b15"
  end

  depends_on "openssl@4"

  def install
    ENV.append_to_cflags "-Dunix"
    platform = Hardware::CPU.intel? ? "x86" : "generic"
    system "make", "#{platform}-openssl",
                   "LIBCRYPTO=#{Formula["openssl@4"].opt_lib}/#{shared_library("libcrypto")}"
    system "make", "install",
                   "PACKAGER=HOMEBREW",
                   "INSTALL_PATH=#{bin}",
                   "MAN_INSTALL_PATH=#{man1}",
                   "DOC_INSTALL_PATH=#{doc}"
  end

  test do
    system bin/"hashcash", "-mb10", "test@example.com"
  end
end
