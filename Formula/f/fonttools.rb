class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/73/e4/5f31f97c859e2223d59ce3da03c67908eb8f8f90d96f2537b73b68aa2a5a/fonttools-4.51.0.tar.gz"
  sha256 "dc0673361331566d7a663d7ce0f6fdcbfbdc1f59c6e3ed1165ad7202ca183c68"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91b7ee931a548862ebecb69c38ac6374499740ef85c040627265493d45577281"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b69b484ef0d85593a9ccb262d61953e5ac4d3d1961c58f51238f3bfeaeb5174"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b8b86aa2679ee00f61be03032f4781d07b447086efc5153a0834d5ac2220d5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "023d28795141474379709b3d35420978553324be568bbacf5ef22ec676e28f1f"
    sha256 cellar: :any_skip_relocation, ventura:        "335cfa6b8c1e122b9bfb5cd0b59c7a760efef9d7cd5a0f982f163f6a0038565c"
    sha256 cellar: :any_skip_relocation, monterey:       "1556473987a0e5e59f4eb1c022c75eebc5c0bf3f783027eaeed273af5aaf844d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35619b3a68018a79ce678d49f08dd4ba5952b3324e91af9dcf205065d4c01f0e"
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
