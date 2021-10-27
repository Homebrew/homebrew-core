class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/33/46/b5d01f8844c84772e950bfc6adcaaa94cd22fedeb7c01776fd6effb3c2f6/mypy-0.910.tar.gz"
  sha256 "704098302473cb31a218f1775a873b376b30b4c18229421e9e9dc8916fd16150"
  license "MIT"
  revision 1

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

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/aa/55/62e2d4934c282a60b4243a950c9dbfa01ae7cac0e8d6c0b5315b87432c81/typing_extensions-3.10.0.0.tar.gz"
    sha256 "50b6f157849174217d0656f99dc82fe932884fb250826c18350e159ec6cdf342"
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
