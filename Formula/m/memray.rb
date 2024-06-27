class Memray < Formula
  include Language::Python::Virtualenv

  desc "Memory profiler for Python applications"
  homepage "https://bloomberg.github.io/memray/"
  url "https://files.pythonhosted.org/packages/cd/2d/5f5068bebafaafe3b9cef8930ab1546a940f9568202394ac6295b2c03509/memray-1.13.0.tar.gz"
  sha256 "ed0b1860e79063cccdb7af14440f56579fd4add91cf5088cedd43ff5c51ee6cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9143f4d9a3c3d482d954ea73c087807c4cfdb6dce59e4089d591d0f7a058787"
    sha256 cellar: :any,                 arm64_ventura:  "3acafce0da2ccd71ad600c19b5874bfc9ee631bbc97ebe3d9fcb2fa82244aef6"
    sha256 cellar: :any,                 arm64_monterey: "4290e4e4db85b37308fd49645d0811de4f890af44ea4afb5a569e45133f47122"
    sha256 cellar: :any,                 sonoma:         "69c7b1e30daed011e69d6deef8b3f6e9e84d12f152fef20bf6273f14ce6840f1"
    sha256 cellar: :any,                 ventura:        "2c13474cfdca182986698c79e53c48003b1df5a0768a045478714be350de0753"
    sha256 cellar: :any,                 monterey:       "ccb4489fe93cb13f9a29c1a1872dfcab9edc69661026e10aa7fc0bbec4db665f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1d810cfa28a600b8c00e1404f8b177c22c0b9f57dc0896d4566ad3dc03202e5"
  end

  depends_on "lz4"
  depends_on "python@3.12"

  on_linux do
    depends_on "elfutils"
    depends_on "libunwind"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
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
    url "https://files.pythonhosted.org/packages/00/6c/79c52651b22b64dba5c7bbabd7a294cc410bfb2353250dc8ade44d7d8ad8/mdit_py_plugins-0.4.1.tar.gz"
    sha256 "834b8ac23d1cd60cec703646ffd22ae97b7955a6d596eb1d304be1e251ae499c"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/21/02/161d6e3dfd1d41ce5b53cee7a85cab0c6df6bacdda75f6c3a5c774beacef/textual-0.70.0.tar.gz"
    sha256 "9ca3f615b5cf442246325e40ef8255424c42b4241d3c62f9c0f96951bab82b1e"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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
