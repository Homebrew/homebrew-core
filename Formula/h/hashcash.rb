class Hashcash < Formula
  desc "Proof-of-work algorithm to counter denial-of-service (DoS) attacks"
  homepage "http://hashcash.org"
  url "http://hashcash.org/source/hashcash-1.22.tgz"
  sha256 "0192f12d41ce4848e60384398c5ff83579b55710601c7bffe6c88bc56b547896"
  license any_of: [:public_domain, "BSD-3-Clause", "LGPL-2.1-only", "GPL-2.0-only"]
  revision 1

  livecheck do
    url "http://hashcash.org/source/"
    regex(/href=.*?hashcash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "4f0504fa7b4b3ae51ffb3163090b4b4309557b5327cac38f203fdf11dfb8e026"
    sha256 cellar: :any,                 arm64_sequoia:  "ff46dc55af54e0d3f0e20308536a4ebd0d08fa18c8ae1797fbc75bf2be97c79f"
    sha256 cellar: :any,                 arm64_sonoma:   "3b7abf77630bc94b21eb0c23dc42ae2922ee662d724958baf8cd4c24df10db15"
    sha256 cellar: :any,                 arm64_ventura:  "8aeaabfc6febb7e6b9c7c163d896f3dd425ea41e74ed49e18312146cdbc66112"
    sha256 cellar: :any,                 arm64_monterey: "c2c65eefb2d69f47865df020f4fce758a783c1a203c11c3055939b153f1ef449"
    sha256 cellar: :any,                 sonoma:         "79b371fdc35215fc8e1c9eb83bca3d2ce1fdcfd5d4b998e186f6f4bf6d01a7eb"
    sha256 cellar: :any,                 ventura:        "351c383a5882cfd727f386588e4003968476a94eb39fd5e41729d9e4aa4e0455"
    sha256 cellar: :any,                 monterey:       "b4fce5f6c16446ee31dca21eac35d6c38a9d61068cb8f59cb37b6eee3196f012"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "635ea819bef9b8f88bfb4b027258804db1e092f4ea235cd34e09261af318cf31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b099580ee6cd7ac69d1c63064049ce5ebb922272245be3f3aeac34943d59274"
  end

  depends_on "openssl@3"

  def install
    ENV.append_to_cflags "-Dunix"
    platform = Hardware::CPU.intel? ? "x86" : "generic"
    system "make", "#{platform}-openssl",
                   "LIBCRYPTO=#{Formula["openssl@3"].opt_lib}/#{shared_library("libcrypto")}"
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
