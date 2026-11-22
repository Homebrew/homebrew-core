class Gita < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple git repos with sanity"
  homepage "https://github.com/nosarthur/gita"
  url "https://files.pythonhosted.org/packages/1d/89/8dd6dd79eadd70ff2f64b79f434637e384cd0490c2a626074e2a73c8a896/gita-0.16.8.2.tar.gz"
  sha256 "064e5cbcfa5df76409cfd8e70142f8153f6ecc40fb35d3a28a0a04054d5fb3fd"
  license "MIT"

  bottle do
    rebuild 3
    manifest_sha256 "bc5b7eb0e60d252c4fe5980967f4d602ce987d349e3848db66e54f1d509c23ce"
    sha256 cellar: :any_skip_relocation, all: "943024f299f7c09bca152aa9daa9070bc47264f23d710ed30fcf159d86e580d2"
  end

  depends_on "python@3.15"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/19/0d/ca63f1b8b706c70590d0a4acc9c3c94ea8ed4dd9c83b4f7af195868abe76/argcomplete-3.8.0.tar.gz"
    sha256 "0114d634013e11ac92cc329b3a7d886c3506e98ddc7bb23c99b1782aacc8b8bd"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gita -v")

    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    (testpath/"README").write "gita"
    system "git", "add", "README"
    system "git", "commit", "--message", "Initial commit"

    system bin/"gita", "add", testpath
    assert_match testpath.basename.to_s, shell_output("#{bin}/gita ls")
  end
end
