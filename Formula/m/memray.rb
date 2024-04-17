class Memray < Formula
  include Language::Python::Virtualenv

  desc "Memory profiler for Python applications"
  homepage "https://bloomberg.github.io/memray/"
  url "https://files.pythonhosted.org/packages/88/8b/0a9854e5b6ce0875f2e2ad163cfecdb8de59fc1a2f1b9a1cb7c683a67826/memray-1.12.0.tar.gz"
  sha256 "3b61c199a60197ae6164a2b44cd828c52de24083ecc49e9ac7d6287686bd68f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c1ced93dc305cb40923d631a90bca6144ef880a8ec5e16b8f8f2ec8ff42d1aa"
    sha256 cellar: :any,                 arm64_ventura:  "c45967b092efb5340cddd34277152d16b7bffccacba170ed8f0d17aae022b9a8"
    sha256 cellar: :any,                 arm64_monterey: "deeda1f684326ce06c1433d5a78c233b8d65377cb105c9c8e34028fc8ccdbb3f"
    sha256 cellar: :any,                 sonoma:         "3d13155df21ecc5abea382aa8510e631b53ad8acc76918b9c7764d863ea2c251"
    sha256 cellar: :any,                 ventura:        "70377574c5b4f7c6b5e327ccbfe0fa523095726512e9d8c143c6df1bd07f3dec"
    sha256 cellar: :any,                 monterey:       "8c5fb25be76c4ac8f6cefaa72e68d3b1d97111b4d186129274b4267210af3453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a9e5964cc9f77cddae6ec0352102caa0918a9f5a25c4c9accd6cca4749dcbcd"
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
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/35/30/2f51da751405bc0fbce8c8dfaf8ee7e9c4941ea28c5c868c2aebfc2748ba/textual-0.56.4.tar.gz"
    sha256 "6f86ae5b4fd750bc48881c941e1a86f7a188c24a862122002e3ac38cd288ef47"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
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
