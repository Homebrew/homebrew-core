class Gptask < Formula
  include Language::Python::Virtualenv

  desc "GPT4 automatic file reviewer and editory"
  homepage "https://github.com/chitalian/gptask"
  url "https://files.pythonhosted.org/packages/72/5a/424f8610cdd28cbcf695f082ff152907ab1eb9f547d23294f21c2c4609f1/gptask_cli-0.1.8.tar.gz"
  sha256 "7469ce3be9789775a453aca94f588041f2041ae93679b54122acb17d092c9813"
  license "MIT"

  depends_on "python@3.11"

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/89/ee/84bbd0161090f0f24e8a2ac175e6b6a936289ee02e9d5da414ce14d3d332/openai-0.27.8.tar.gz"
    sha256 "2483095c7db1eee274cebac79e315a986c4e55207bb4fa7b82d185b3a2ed9536"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "echo", "hello", ">>", "temp.txt"
    output = shell_output("#{bin}/run_gptask -f -p doc-reviewer temp.txt 2>&1", 1)
    assert_match "[Errno 2] No such file or directory", output
  end
end
