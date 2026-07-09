class GitCrypt < Formula
  desc "Enable transparent encryption/decryption of files in a git repo"
  homepage "https://www.agwa.name/projects/git-crypt/"
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.8.0.tar.gz"
  sha256 "540d424f87bed7994a4551a8c24b16e50d3248a5b7c3fd8ceffe94bfd4af0ad9"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?git-crypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7600d5908af7e3dcc489f1e973327cd8ac41b3d259d1490b7203b37aa0aff9a0"
    sha256 cellar: :any,                 arm64_sequoia: "7b918e96fa98416e4f4bd3eadc188667c39668e59629011740d675802d6f1cb8"
    sha256 cellar: :any,                 arm64_sonoma:  "1a317787886fe947557c08f4450a4be7d6e5e7815b8bcb214692784b638986a7"
    sha256 cellar: :any,                 sonoma:        "c838c13b346548c0ec41951a7461f25af63aacdff96ffc41eb71c29f15834625"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1653fb825aa95ab80e3b8e52deedcd2272a60433ad8a12dba5b0c2a667a32e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6062bcc3728de1a25ba30976a81cfcca09887762639fbdf91318e579c9fc0db8"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "openssl@4"

  uses_from_macos "libxslt" => :build

  def install
    # fix docbook load issue
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "make", "ENABLE_MAN=yes", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"git-crypt", "keygen", "keyfile"
  end
end
