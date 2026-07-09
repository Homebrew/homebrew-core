class GitRemoteHg < Formula
  include Language::Python::Shebang

  desc "Transparent bidirectional bridge between Git and Mercurial"
  homepage "https://github.com/felipec/git-remote-hg"
  url "https://github.com/felipec/git-remote-hg/archive/refs/tags/v0.7.tar.gz"
  sha256 "ada593c2462bed5083ab0fbd50b9406b8e83b04a6c882de80483e7c77ce8bf07"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/felipec/git-remote-hg.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "39dc290161415c5eff6a64fe5903931ef9b6ec077dc8d44f90328566e722e9b4"
  end

  depends_on "asciidoctor" => :build
  depends_on "mercurial"
  depends_on "python@3.14"

  conflicts_with "git-cinnabar", because: "both install `git-remote-hg` binaries"

  # Workaround for Mercurial 7.2+
  # PR ref: https://github.com/felipec/git-remote-hg/pull/100
  patch do
    url "https://github.com/felipec/git-remote-hg/commit/bad0a3e5e5dd8352b3ea67d6efa8584ebde5311e.patch?full_index=1"
    sha256 "9a9e1f052571b48747d1c14bd5f09dcf4778b64bb2673ecc9987f46d03537105"
  end
  patch do
    url "https://github.com/felipec/git-remote-hg/commit/e7ac1caffaf7518d17e158d41f35fe1e0ba057b8.patch?full_index=1"
    sha256 "6177d0e7800e8553ba4976c7746772f3179617a674b229905114228f1ce0c94b"
  end

  def install
    rewrite_shebang detected_python_shebang, "git-remote-hg"
    system "make", "install", "prefix=#{prefix}"

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "install-doc", "prefix=#{prefix}"
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
  end
end
