class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "https://links.twibright.com/"
  url "https://links.twibright.com/download/links-2.30.tar.bz2"
  sha256 "c4631c6b5a11527cdc3cb7872fc23b7f2b25c2b021d596be410dadb40315f166"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6ee67f16e936f4ee03ed3f99c64e702dcf4475fc9ef2159f80cb1bfb41992e48"
    sha256 cellar: :any,                 arm64_sequoia: "b93b70807720924ff7df8ec8fa54a291ed1363d2113de28ddf6b8a26e8cb6a34"
    sha256 cellar: :any,                 arm64_sonoma:  "396cd3d372b7f3cef0e8c037cd4401331d40c924935e4faf1c6311d425bf50eb"
    sha256 cellar: :any,                 sonoma:        "361875cdc9395d2ed97c87e0921c40c60d456ad49b4d9d0e7b8ddf78f39efacc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5428de9880c1e619b93507a3d4acb7d4ee709323b10d3339148ec1c75ff87e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a79dc1b18b5ef645e53246d0b13fedc1395492fef5bbaf979ae087e89f0bc2"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--mandir=#{man}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          "--without-lzma",
                          *std_configure_args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
