class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/40/3c/3464b567aa367b221fa610bbbcce8015bf953977d21e52f2d711b526fb48/flake8-7.0.0.tar.gz"
  sha256 "33f96621059e65eec474169085dc92bf26e7b2d47366b70be2f67ab80dc25132"
  license "MIT"
  head "https://github.com/PyCQA/flake8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58d022fe3b66d606522094f231789c8b6ba40e8cc274474a657114346e2ce56e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fca4abfdfb97bce4e4bcdd6c78035371f97ca8d7f99a7a52f1d09fc6ee7e44a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43d748b21b5caf9ed0f228faf6ed4f6413a1b2cc8e86f233f6337b65e1fdc6c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "615e0980cec89aa0a12977400eeb405938bfc18af2d0652114116072f964f8ec"
    sha256 cellar: :any_skip_relocation, ventura:        "49f2f677278bffc731d398df2b88a5a2859c001ba95611dd7b6205cc78e9c0ce"
    sha256 cellar: :any_skip_relocation, monterey:       "70cd48ca22ecf545b30dc6d9783ced77ae377c372f8c895b58247c509ea1f1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eae42f759534262c825019f37ecedc89bce87130cd74a93d7441b54e7a0b7b92"
  end

  depends_on "python@3.12"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/34/8f/fa09ae2acc737b9507b5734a9aec9a2b35fa73409982f57db1b42f8c3c65/pycodestyle-2.11.1.tar.gz"
    sha256 "41ba0e7afc9752dfb53ced5489e89f8186be00e599e712660695b7a75ff2663f"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/57/f9/669d8c9c86613c9d568757c7f5824bd3197d7b1c6c27553bc5618a27cce2/pyflakes-3.2.0.tar.gz"
    sha256 "1c61603ff154621fb2a9172037d84dca3500def8c8b630657d1701f026f8af3f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-bad.py").write <<~EOS
      print ("Hello World!")
    EOS

    (testpath/"test-good.py").write <<~EOS
      print("Hello World!")
    EOS

    assert_match "E211", shell_output("#{bin}/flake8 test-bad.py", 1)
    assert_empty shell_output("#{bin}/flake8 test-good.py")
  end
end
