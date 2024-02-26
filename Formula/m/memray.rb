class Memray < Formula
  include Language::Python::Virtualenv

  desc "Memory profiler for Python applications"
  homepage "https://bloomberg.github.io/memray/"
  url "https://files.pythonhosted.org/packages/b9/3b/0af451f20f8a72b3dcfdf65c6d5639469a92db3f333e3c344a6b5cc12732/memray-1.11.0.tar.gz"
  sha256 "f72c111a4868d0f2b4e4fb9ba4da736db8c73b6fb0ac6e6f2deca8ee540eb688"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "59c0f7bd9f706792cd4c2635b9d2c08ab9ae1424fef226e423a1dba7cdba75f0"
    sha256 cellar: :any,                 arm64_ventura:  "cc1236f2987157ea213b704d80f3c8b7ad5d97e8d4ce3e4cf25a90f2856dda59"
    sha256 cellar: :any,                 arm64_monterey: "181b183a12ec2fe8718f279f94cdda690c6cf2008fe25b276fe2083e4cc8fa6d"
    sha256 cellar: :any,                 sonoma:         "2c8bab2b26820b65d0ab21374f368adc278d643de06049afbc46665e22e8ad16"
    sha256 cellar: :any,                 ventura:        "aa5f7fcb775e8b10cfe5d44e7cd7d38157043f4c89c9defc8b6cf96f414aa1e4"
    sha256 cellar: :any,                 monterey:       "ab4c255db68bfd50c7ce55b8bec6ee3560024ef1d2dc30d7b2ea46bf56682a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dae408d451554221f662a17822de809c76a89af812e936cff3a3cba704fe101"
  end

  depends_on "lz4"
  depends_on "python@3.12"

  on_linux do
    depends_on "libunwind"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b4/db/61960d68d5c39ff0dd48cb799a39ae4e297f6e9b96bf2f8da29d897fba0c/mdit_py_plugins-0.4.0.tar.gz"
    sha256 "d8ab27e9aed6c38aa716819fedfde15ca275715955f8a185a8e1cf90fb1d2c1b"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/bb/ce/b224ccc05260871da8df640e7cd8ca0a5e38721fddb6733650195402841e/textual-0.52.1.tar.gz"
    sha256 "4232e5c2b423ed7c63baaeb6030355e14e1de1b9df096c9655b68a1e60e4de5f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/memray", "run", "--output", "output.bin", "-c", "print()"
    assert_predicate testpath/"output.bin", :exist?

    assert_match version.to_s, shell_output("#{bin}/memray --version")
  end
end
