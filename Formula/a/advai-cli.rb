class AdvaiCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for managing AdvAI skills and external CLIs"
  homepage "https://github.com/Advai-X/advai-x-cli"
  url "https://files.pythonhosted.org/packages/4d/b0/69f7d9356ad4692ba588ccbc4976e9c9757d81c1d680cc9b7ae4d93914db/advai_cli-1.0.4.tar.gz"
  sha256 "81ac57e7eae6d964df174c55d89071309fd0b2fe551c2ed6e53197f3e65b977d"
  license "MIT"

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"home").mkpath
    ENV["HOME"] = testpath/"home"

    assert_match version.to_s, shell_output("#{bin}/advai --version")
    system bin/"advai", "skill", "install", "demo-skill"
    assert_match "demo-skill", shell_output("#{bin}/advai skill list")
    assert_match "demo-skill", shell_output("#{bin}/advai skill info demo-skill")
  end
end
