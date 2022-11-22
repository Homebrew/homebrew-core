class GitCrypt < Formula
  desc "Enable transparent encryption/decryption of files in a git repo"
  homepage "https://www.agwa.name/projects/git-crypt/"
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.7.0.tar.gz"
  sha256 "50f100816a636a682404703b6c23a459e4d30248b2886a5cf571b0d52527c7d8"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?git-crypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "0fa83aa6dc1b794075e1a959c27ba858024f234c52d390c048a7b01538c089a0"
    sha256 cellar: :any,                 arm64_monterey: "e062f956b5b18899552b3389177be8f69f7cc41c4aee5688b40c2e4249ec9b98"
    sha256 cellar: :any,                 arm64_big_sur:  "f33b245d7f7948d3af259bb7faacdf37a83931e73e6f0e7e28f826b49fbff1c3"
    sha256 cellar: :any,                 ventura:        "02d70c5e710b98eb4a9d1e95fd5265bff5b09841df7aa629f9576596d1ddcae9"
    sha256 cellar: :any,                 monterey:       "9a63b27a7544ebd2eba62ec5b744e8e278fd239451cba5dc6e876e5cdb59f581"
    sha256 cellar: :any,                 big_sur:        "d70c2f3e01239cf5294762cfcafecfe70d977c395da50bedd45f990d5bcc1b23"
    sha256 cellar: :any,                 catalina:       "0681b6a663f89c9e4d18d057ede3cd9116c6d3685c5a08e4f75aec38a9900971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c775788bff6d5c72d93098a866cf202a2d8ab397932c25702f06d1def1fe91a"
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
