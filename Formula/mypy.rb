class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/d4/0f/3c74d419a1d2e1c683cc174b8a0fac36dfb0d14c8b9b28905e1ca401ec03/mypy-0.920.tar.gz"
  sha256 "a55438627f5f546192f13255a994d6d1cf2659df48adcf966132b4379fd9c86b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "597e36e60cabe3d242cd0dfb52885d4ecfd36d64836f8a83439a134c6b2d5326"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55c4564fe7228ecf64f9421507440f38522732420afe3b68d4a78ff4ce2d3083"
    sha256 cellar: :any_skip_relocation, monterey:       "864f02a7a280feff1d8d867ba512687838c1fa683cbd3a1409880e96e14114be"
    sha256 cellar: :any_skip_relocation, big_sur:        "50e86679593a40696a3bf8c6af6e55c60a5315f6eb1aeb7dcf0e43d8d88b08da"
    sha256 cellar: :any_skip_relocation, catalina:       "cc49f99a9f48eca2a09e0f79b107f34b03afbde863eaaf8abea5938f0978c0b5"
    sha256 cellar: :any_skip_relocation, mojave:         "bd13c0f849d19e6ad9d5d2a019473fffc2cc610f1beab6dfb5c6a368735d0330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c28f7a6624c09213e25d82ad6f5a06543f21f4f81638814c1f8b360d0605dc9"
  end

  depends_on "python@3.10"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/3d/6e/d290c9bf16159f02b70c432386aa5bfe22c2857ff460591912fd907b61f6/tomli-2.0.0.tar.gz"
    sha256 "c292c34f58502a1eb2bbb9f5bbc9a5ebc37bee10ffb8c2d6bbdfa8eb13cc14e1"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0d/4a/60ba3706797b878016f16edc5fbaf1e222109e38d0fa4d7d9312cb53f8dd/typing_extensions-4.0.1.tar.gz"
    sha256 "4ca091dea149f945ec56afb48dae714f21e8692ef22a395223bcd328961b6a0e"
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
