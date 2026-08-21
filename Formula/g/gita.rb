class Gita < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple git repos with sanity"
  homepage "https://github.com/nosarthur/gita"
  url "https://files.pythonhosted.org/packages/1d/89/8dd6dd79eadd70ff2f64b79f434637e384cd0490c2a626074e2a73c8a896/gita-0.16.8.2.tar.gz"
  sha256 "064e5cbcfa5df76409cfd8e70142f8153f6ecc40fb35d3a28a0a04054d5fb3fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc72413817dbb2e9686758990e6595ae4a83ce9c40e6d2fe7d89ee51062c044a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc72413817dbb2e9686758990e6595ae4a83ce9c40e6d2fe7d89ee51062c044a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc72413817dbb2e9686758990e6595ae4a83ce9c40e6d2fe7d89ee51062c044a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7918b6426b70f7976e28344d41797aa31d766c37aad221380d3e9dabf985f15c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7918b6426b70f7976e28344d41797aa31d766c37aad221380d3e9dabf985f15c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7918b6426b70f7976e28344d41797aa31d766c37aad221380d3e9dabf985f15c"
  end

  depends_on "python@3.14"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/95/c0/c8e94135e66fabf89a120d9b4b123fe6993506beca6c1938a74c24cfa5fd/argcomplete-3.7.0.tar.gz"
    sha256 "afde224f753f874807b1dc1414e883ab8fe0cda9c04807b6047dcb8e1ac23913"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
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
