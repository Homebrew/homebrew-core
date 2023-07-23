class Gptask < Formula
  include Language::Python::Virtualenv

  desc "The ultimate file editor powered by GPT4"
  homepage "https://github.com/chitalian/gptask"
  url "https://files.pythonhosted.org/packages/72/5a/424f8610cdd28cbcf695f082ff152907ab1eb9f547d23294f21c2c4609f1/gptask_cli-0.1.8.tar.gz"
  sha256 "7469ce3be9789775a453aca94f588041f2041ae93679b54122acb17d092c9813"
  license "MIT"

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "echo", "hello", ">>", "temp.txt"
    output = shell_output("#{bin}/run_gptask -f -p doc-reviewer temp.txt 2>&1", 1)
    assert_match "[Errno 2] No such file or directory", output
  end
end
