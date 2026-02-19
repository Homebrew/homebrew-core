class AdrViewer < Formula
  include Language::Python::Virtualenv

  desc "Generate easy-to-read web pages for your Architecture Decision Records"
  homepage "https://github.com/mrwilson/adr-viewer"
  url "https://files.pythonhosted.org/packages/1b/72/0f787da38d0f9d69c06b31d8f412735ed4fad383edd7f7d2286f4fc7b5b0/adr_viewer-1.4.0.tar.gz"
  sha256 "9a2f02a9feb3a6d03d055dd8599b20d34126f8e755b4b4ee1a353ecbbd590cef"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3f6b7a95651b6fb125de9bf527bacacfaaedb388d7b04f70d4403b8035e2c8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58ab44ead9b88068a4cd4a4d5e7623b5769c6b614e888374ba863e9d0e0a5d06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc342d015274358ca7077ce8552140d0f71fec60c06c9567c11086ddb76ff447"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b31b8e4db34d9255f45a69b7a1bafeb8c847766cd13fb7a855c0aa23fa8c88b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "831b524d372bbe7f6a292e141f1d87b0516e1f3f067cf24309066926ec397fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3043b26cd6a9c4f8dcf48da0045d79860b6697742b108eb49ef7695e3a1f94d"
  end

  depends_on "python@3.14"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/f0/3c/adaf39ce1fb4afdd21b611e3d530b183bb7759c9b673d60db0e347fd4439/beautifulsoup4-4.13.3.tar.gz"
    sha256 "1bd32405dacc920b42b83ba01644747ed77456a65760e285fbc47633ceddaf8b"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/1b/fb/97839b95c2a2ea1ca91877a846988f90f4ca16ee42c0bb79e079171c0c06/bottle-0.13.2.tar.gz"
    sha256 "e53803b9d298c7d343d00ba7d27b0059415f04b9f6f40b8d58b5bf914ba9d348"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/80/f7/f6d06304c61c2a73213c0a4815280f70d985429cda26272f490e42119c1a/mistune-3.1.2.tar.gz"
    sha256 "733bf018ba007e8b5f2d3a9eb624034f6ee26c4ea769a98ec533ee111d504dff"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"adr-viewer", shell_parameter_format: :click)
  end

  test do
    adr_dir = testpath/"doc/adr"
    mkdir_p adr_dir
    (adr_dir/"0001-record.md").write <<~MARKDOWN
      # 1. Record architecture decisions
      Date: 2018-09-02
      ## Status
      Accepted
      ## Context
      We need to record the architectural decisions made on this project.
      ## Decision
      We will use Architecture Decision Records, as [described by Michael Nygard](https://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions).
      ## Consequences
      See Michael Nygard's article, linked above. For a lightweight ADR toolset, see Nat Pryce's [adr-tools](https://github.com/npryce/adr-tools).
    MARKDOWN
    system bin/"adr-viewer", "--adr-path", adr_dir, "--output", "index.html"
    assert_path_exists testpath/"index.html"
  end
end
