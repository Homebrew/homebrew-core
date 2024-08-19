class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/c6/cb/cd80a0da995adde8ade6044a8744aee0da5efea01301cadf770f7fbe7dcc/fonttools-4.53.1.tar.gz"
  sha256 "e128778a8e9bc11159ce5447f76766cefbd876f44bd79aff030287254e4752c4"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70398639ade205d56fa1aa2f9414c6438acc42b272afdbef4e616673b8659226"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c8c8525646be9bdde781407c258a52a486b890c185769d5f29154ec3f4ee768"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3447c5dee8bcacc8f810ca18d107cabfd6b354911c73b85fc33ef970d87f77e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "918143a0ba840fcb05535c4a69f93f73b38a0bccc25883008cabecf2a2f7a444"
    sha256 cellar: :any_skip_relocation, ventura:        "8c22df7ab78cde9df3ed4a370e94337461b75161349380a3b934dab411b7653d"
    sha256 cellar: :any_skip_relocation, monterey:       "69afab1869d663af5414e47254e1862ddaf656d6ad748df8fabd8ff8bddacd63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c2539a85db47a3153a12df441761c7e58ce79081aa9d16715467525cf485077"
  end

  depends_on "python@3.12"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/92/d8/71230eb25ede499401a9a39ddf66fab4e4dab149bf75ed2ecea51a662d9e/zopfli-0.2.3.zip"
    sha256 "dbc9841bedd736041eb5e6982cd92da93bee145745f5422f3795f6f258cdc6ef"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.ttx", :exist?
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.woff2", :exist?
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
