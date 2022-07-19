class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/5e/66/00f7f751140fe6953603fb0cd56dee0314842cfe358884ca3025589ca81c/mypy-0.971.tar.gz"
  sha256 "40b0f21484238269ae6a57200c807d80debc6459d444c0489a102d7c6a75fa56"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eea7c74afc17105c42e966afc34ea619550feab44e1ea3f38b84c0e76e3cd68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c96c4dde1f17ef1c958aeea85d1879962cdb6ebb2e432b7b30323a19b7c0ba3"
    sha256 cellar: :any_skip_relocation, monterey:       "de868ec1d5304f6498e39be2fd65d246d522bac34ad96681fda025760db60853"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a0fc82ba988ed3f4cfbae322eb20fb13705dfee2299e68d1a32e4727d7e88e8"
    sha256 cellar: :any_skip_relocation, catalina:       "d5a755f066fc57568cf8d1fa6a7c44871dc72636e9a1c4a5071457b09341714a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bad624480d31778b9043f5a8f4f30998703a399a9386a925a698cd48a9b4c1e1"
  end

  depends_on "python@3.10"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/9e/1d/d128169ff58c501059330f1ad96ed62b79114a2eb30b8238af63a2e27f70/typing_extensions-4.3.0.tar.gz"
    sha256 "e6d2677a32f47fc7eb2795db1dd15c1f34eff616bcaf2cfb5e997f854fa1c4a6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output
  end
end
