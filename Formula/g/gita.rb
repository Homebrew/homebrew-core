class Gita < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple git repos with sanity"
  homepage "https://github.com/nosarthur/gita"
  url "https://files.pythonhosted.org/packages/1d/89/8dd6dd79eadd70ff2f64b79f434637e384cd0490c2a626074e2a73c8a896/gita-0.16.8.2.tar.gz"
  sha256 "064e5cbcfa5df76409cfd8e70142f8153f6ecc40fb35d3a28a0a04054d5fb3fd"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b18bd40bbdad6e3ca2ff51905f61e54bb55ec4916b21c0b88277bdb357fe334f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b18bd40bbdad6e3ca2ff51905f61e54bb55ec4916b21c0b88277bdb357fe334f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b18bd40bbdad6e3ca2ff51905f61e54bb55ec4916b21c0b88277bdb357fe334f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a4dbac27efe6de013d6b48890a20ca425b509b3bb9b1ee8f60b9547f18056c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a4dbac27efe6de013d6b48890a20ca425b509b3bb9b1ee8f60b9547f18056c93"
  end

  depends_on "python@3.15"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
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
