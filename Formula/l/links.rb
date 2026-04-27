class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "https://links.twibright.com/"
  url "https://links.twibright.com/download/links-2.30.tar.bz2"
  sha256 "c4631c6b5a11527cdc3cb7872fc23b7f2b25c2b021d596be410dadb40315f166"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "033baf6900816d9cfa21fd82ee9607a7b8863cc58586febdded445fa5144d776"
    sha256 cellar: :any,                 arm64_sequoia: "56ea94e2f392a60f0c376e82b95dde9c38db9180460607687a9c95350d2e94b2"
    sha256 cellar: :any,                 arm64_sonoma:  "d3bd10a8536c211e6bc5f1f07ea95f0850f3c4196ca9c1e14aafeb2d46b209f7"
    sha256 cellar: :any,                 sonoma:        "f8ab45d54adf14d47f60c740c175022c5a8005f47dc82d34156cc8d92dfcfcf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4de89adcd0504e2b304f0b9d83e868b84a510676b717b8f91b8a0e604a90d0b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ff5ab594bb27cf5f888d48fae1525ecfd945541a09aa549738253abdb2dffbc"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--mandir=#{man}",
                          "--with-ssl=#{Formula["openssl@4"].opt_prefix}",
                          "--without-lzma",
                          *std_configure_args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
