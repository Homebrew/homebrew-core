class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/dc/9b/9f254b434ed6af1e8566a398660c9f8ecada95ccf03ed799e09637a13b77/eg-1.2.3.tar.gz"
  sha256 "31f221b24701a9fc4b034d9593f081859d943b14bf26b2e98190509b64e2622b"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "cb81851daf9392a718d867de6024ff0a40a1b3642d4b027338b01e37226a4c03"
  end

  depends_on "python@3.15"

  conflicts_with "eg", because: "both install `eg` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end
