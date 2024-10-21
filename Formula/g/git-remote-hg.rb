class GitRemoteHg < Formula
  include Language::Python::Shebang

  desc "Transparent bidirectional bridge between Git and Mercurial"
  homepage "https://github.com/felipec/git-remote-hg"
  url "https://github.com/felipec/git-remote-hg/archive/refs/tags/v0.6.tar.gz"
  sha256 "1d49ffda290c8a307d32191655bdd85015e0e2f68bb2d64cddea04d8ae50a4bf"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/felipec/git-remote-hg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6592f095be3024d5ecca8b285d7fad64f9852c232e1c670d53961a0ee6d1c193"
  end

  depends_on "asciidoctor" => :build
  depends_on "mercurial"
  depends_on "python@3.13"

  conflicts_with "git-cinnabar", because: "both install `git-remote-hg` binaries"

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
