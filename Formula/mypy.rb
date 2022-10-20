class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/0d/75/a1ec1af4153f7b7ae825705ada667bf445418277153c76972ba0ad782bb9/mypy-0.982.tar.gz"
  sha256 "85f7a343542dc8b1ed0a888cdd34dca56462654ef23aa673907305b260b3d746"
  license "MIT"
  revision 1
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5db98491c63eada82a16a653defdf64a0db77656a7804ed8930ee8ef6eff2684"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0de2856e1a828a882ca37717ac40591c53df72021d20ecf23e5628c0c6267c81"
    sha256 cellar: :any_skip_relocation, monterey:       "1a09db3fce6bab31a0fd32c4f990dc2c5442911dcd38a040781ff3b0cff30112"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3594fb59b3b7d32429dc98b26c9b953f44c9dd5e0d960ab1816068e1df2633f"
    sha256 cellar: :any_skip_relocation, catalina:       "65a212dab20932df2fa6d7be5dc4ad91618dae69bbf8a6b641111430121b67da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "228875cc1ce5ec72385bc8f717c1b184c4ee5fa7a7685a109c2b0f9dc66d4567"
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
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
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

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
