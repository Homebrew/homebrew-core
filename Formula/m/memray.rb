class Memray < Formula
  include Language::Python::Virtualenv

  desc "Memory profiler for Python applications"
  homepage "https://bloomberg.github.io/memray/"
  url "https://files.pythonhosted.org/packages/88/8b/0a9854e5b6ce0875f2e2ad163cfecdb8de59fc1a2f1b9a1cb7c683a67826/memray-1.12.0.tar.gz"
  sha256 "3b61c199a60197ae6164a2b44cd828c52de24083ecc49e9ac7d6287686bd68f3"
  license "Apache-2.0"
  revision 1

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
    url "https://files.pythonhosted.org/packages/b4/db/61960d68d5c39ff0dd48cb799a39ae4e297f6e9b96bf2f8da29d897fba0c/mdit_py_plugins-0.4.0.tar.gz"
    sha256 "d8ab27e9aed6c38aa716819fedfde15ca275715955f8a185a8e1cf90fb1d2c1b"
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
    url "https://files.pythonhosted.org/packages/11/8d/70bc2b5ac7c0860678daa915f39a8907664c1d1d93e6b497df4fff752353/textual-0.58.1.tar.gz"
    sha256 "3a01be0b583f2bce38b8e9786b75ed33dddc816bba502d8e7a9ca3ca2ead3957"
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
