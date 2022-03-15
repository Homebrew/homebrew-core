class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/3e/9f/9f408ca2ed4004e4303649087449556db769b341390dbc21a6075f02bc7d/mypy-0.941.tar.gz"
  sha256 "cbcc691d8b507d54cb2b8521f0a2a3d4daa477f62fe77f0abba41e5febb377b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fe62f732b116c18d1e8728818bae73c8daf4143bc6c623624e69ffc0702becd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "336b5646b5976c876df5dabf0fb6e3a154802f7443b8259af2615f2f835d5615"
    sha256 cellar: :any_skip_relocation, monterey:       "0ee93bdd3efea9a3827aab5f2155ebb76f90dded5a89407836c1fd9f56ed3ba2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee85dbd37ca430a7fcbce66ddb14a03a4c7636d6b8394e37766e1a234266fc54"
    sha256 cellar: :any_skip_relocation, catalina:       "86f544c318f49158b6d40010cce1e1bf6f42704c2891cf251b03b54b8768852e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f06553d4e3097748f8c381fe2e4fc073a25d1b46c71ccc4415b75c2bab00cde"
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
    url "https://files.pythonhosted.org/packages/b1/5a/8b5fbb891ef3f81fc923bf3cb4a578c0abf9471eb50ce0f51c74212182ab/typing_extensions-4.1.1.tar.gz"
    sha256 "1a9462dcc3347a79b1f1c0271fbe79e844580bb598bafa1ed208b94da3cdcd42"
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
