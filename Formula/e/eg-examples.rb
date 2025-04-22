class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/dc/9b/9f254b434ed6af1e8566a398660c9f8ecada95ccf03ed799e09637a13b77/eg-1.2.3.tar.gz"
  sha256 "31f221b24701a9fc4b034d9593f081859d943b14bf26b2e98190509b64e2622b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1c10604e24a6e315bb4ac0f066ecd76da2315b225dd7d567ef926fcefe883fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1c10604e24a6e315bb4ac0f066ecd76da2315b225dd7d567ef926fcefe883fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1c10604e24a6e315bb4ac0f066ecd76da2315b225dd7d567ef926fcefe883fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "56b83d2d2a2927a790dd69e41bdbb033f9ccefbe1b389f8a8378caf05254e1b6"
    sha256 cellar: :any_skip_relocation, ventura:       "56b83d2d2a2927a790dd69e41bdbb033f9ccefbe1b389f8a8378caf05254e1b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93c6f25ff21ea5cac03dd7195c058f38930c78f748838ed05d35029860372c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1c10604e24a6e315bb4ac0f066ecd76da2315b225dd7d567ef926fcefe883fb"
  end

  depends_on "python@3.13"

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
