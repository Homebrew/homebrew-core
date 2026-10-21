class GitRemoteHg < Formula
  include Language::Python::Shebang

  desc "Transparent bidirectional bridge between Git and Mercurial"
  homepage "https://github.com/felipec/git-remote-hg"
  url "https://github.com/felipec/git-remote-hg/archive/refs/tags/v0.7.tar.gz"
  sha256 "ada593c2462bed5083ab0fbd50b9406b8e83b04a6c882de80483e7c77ce8bf07"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/felipec/git-remote-hg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e90eff0db403519edc1c7a28c118fca81a007fe16ca8b909d80b320136d26bfa"
  end

  depends_on "asciidoctor" => :build
  depends_on "mercurial"
  depends_on "python@3.15"

  conflicts_with "git-cinnabar", because: "both install `git-remote-hg` binaries"

  # Workaround for Mercurial 7.2+
  patch do
    url "https://github.com/felipec/git-remote-hg/commit/bad0a3e5e5dd8352b3ea67d6efa8584ebde5311e.patch?full_index=1"
    sha256 "9a9e1f052571b48747d1c14bd5f09dcf4778b64bb2673ecc9987f46d03537105"
    type :backport
  end
  patch do
    url "https://github.com/felipec/git-remote-hg/commit/e7ac1caffaf7518d17e158d41f35fe1e0ba057b8.patch?full_index=1"
    sha256 "6177d0e7800e8553ba4976c7746772f3179617a674b229905114228f1ce0c94b"
    type :unofficial
    resolves "https://github.com/felipec/git-remote-hg/pull/100"
  end

  deny_network_access!

  def install
    rewrite_shebang detected_python_shebang, "git-remote-hg"
    system "make", "install", "prefix=#{prefix}"

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "install-doc", "prefix=#{prefix}"
  end

  test do
    mkdir "hg-repo" do
      system "hg", "init"
      (testpath/"hg-repo/hello.txt").write "hello world\n"
      system "hg", "add", "hello.txt"
      system "hg", "--config", "ui.username=brew", "commit", "-m", "initial commit"
    end

    system "git", "clone", "hg::#{testpath}/hg-repo", "git-repo"

    assert_path_exists testpath/"git-repo/hello.txt"
    assert_match "hello world", (testpath/"git-repo/hello.txt").read
    assert_match "initial commit", shell_output("git -C git-repo log -1")
  end
end
