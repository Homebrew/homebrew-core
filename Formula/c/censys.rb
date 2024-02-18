class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https://github.com/censys/censys-python"
  url "https://files.pythonhosted.org/packages/64/e2/60e8e2922e64ba38de3948c1ab04cdca6698920bc98d13637f77a259ea08/censys-2.2.11.tar.gz"
  sha256 "d4e161e3085800c0f9b6ff6cc035a7727ff525135cdde62ff01e32eb371c5773"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df8d3b86974b6d7adc9ae30a3bd4a155249e6e8f378814debffff35807f4f1a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae87fd17d37c5a8ad93ec29a7e5927ac64ea309404cb64c641ecfd221237ef29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5490483389e3be71e0fa2370943738bc40b3cb6c419a6759f498935d1f885a12"
    sha256 cellar: :any_skip_relocation, sonoma:         "eab4929c58946a72746dee13d18343e562a1185dfd3d7d56a14ea5924c8c92de"
    sha256 cellar: :any_skip_relocation, ventura:        "005fde131c87e5209bb82f68cd05e6bae0eaf6f3590f905af62b967b8a24a5fd"
    sha256 cellar: :any_skip_relocation, monterey:       "14d46d1f507715b28ab341b253c5a4fc051be492c44f0d6109cbca1e9d273fe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f1aa50a680d5f31b4fd5af52f3327de3396f08b29ace4224f41249986a31f16"
  end

  depends_on "pygments"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: censys", shell_output("#{bin}/censys --help")
    assert_equal "Censys Python Version: #{version}", shell_output("#{bin}/censys --version").strip
    assert_match "Successfully configured credentials", pipe_output("#{bin}/censys asm config", "test\nn\n", 0)
  end
end
