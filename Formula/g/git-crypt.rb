class GitCrypt < Formula
  desc "Enable transparent encryption/decryption of files in a git repo"
  homepage "https://www.agwa.name/projects/git-crypt/"
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.7.0.tar.gz"
  sha256 "50f100816a636a682404703b6c23a459e4d30248b2886a5cf571b0d52527c7d8"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?git-crypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a9e4eda2135a14c3a3a87fa5b3812858185361d5c4f04bf6d8c8603cc1700fdd"
    sha256 cellar: :any,                 arm64_ventura:  "4b3a389b9dbf8a9f3e03009ec3b591dbe4814799b42e8708dc7690d1cce6b362"
    sha256 cellar: :any,                 arm64_monterey: "8f36b845135fef7f95c1836cce21522ed8c95ab43d3392bd0221268fd61dd1fb"
    sha256 cellar: :any,                 sonoma:         "311fdbce0d28379fccb498a2dbd28fd0970e28435093fec017b764085d2cb6f4"
    sha256 cellar: :any,                 ventura:        "58ce66439704ae0c12b982716ab3621e1f8aa4db9626038390e94b415eaa0e98"
    sha256 cellar: :any,                 monterey:       "ca996f9c7ca04bdae361bcf51f7c88a1ba872442e7734b3d06681e209e2af960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a4b02697b5b69721c024e072e8a9a2bf0227051bae968305dfdf34a88ff2bf8"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build

  def install
    # fix docbook load issue
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.append_to_cflags "-DOPENSSL_API_COMPAT=0x30000000L"

    system "make", "ENABLE_MAN=yes", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/git-crypt", "keygen", "keyfile"
  end
end
