class GitCrypt < Formula
  desc "Enable transparent encryption/decryption of files in a git repo"
  homepage "https://www.agwa.name/projects/git-crypt/"
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.8.0.tar.gz"
  sha256 "540d424f87bed7994a4551a8c24b16e50d3248a5b7c3fd8ceffe94bfd4af0ad9"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?git-crypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "406d6b431081540da5ffac631e736ad29046ad5a10d3f9765b03d53129846188"
    sha256 cellar: :any,                 arm64_sequoia: "48614fc994fde691b6878a1ea9075d5d9da6b837555d882e5644fd2d55dd09b3"
    sha256 cellar: :any,                 arm64_sonoma:  "cec4e48761c805edae828f411b4831f1aeff7fedb2ecf77a094ff627812e9173"
    sha256 cellar: :any,                 sonoma:        "3f12d10fad264b7c738ff5c9afb4fdbda6d9178a2ba601507179fc57a446450a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e63acf43e312923852fef13c2ac54950fbb7c2dedbca177e7440b611cbc1b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d076be65893a0c7a8125a6456cae3757557d660b3d3c5eabb42c1be6693f554"
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
    system bin/"git-crypt", "keygen", "keyfile"
  end
end
