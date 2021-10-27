class NameThatHash < Formula
  include Language::Python::Virtualenv

  desc "Modern hash identification system"
  homepage "https://nth.skerritt.blog/"
  url "https://files.pythonhosted.org/packages/32/58/1f4052bd4999c5aceb51c813cc8ef32838561c8fb18f90cf4b86df6bd818/name-that-hash-1.10.0.tar.gz"
  sha256 "aabe1a3e23f5f8ca1ef6522eb1adcd5c69b5fed3961371ed84a22fc86ee648a2"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/HashPals/Name-That-Hash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae9c171eb148b7ab8b0bf920e4bcad8bbddd96f6c3b5db4be724a76f85edcf04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc73b66e0f36f2e0c829eaff2fdbe831ceeaa0aff1db8d01554c4eed6abe57b5"
    sha256 cellar: :any_skip_relocation, monterey:       "cecf255bcd73d7e11f7d51cad2f48dfd53a691877fbbe1b93fd62538517cbd26"
    sha256 cellar: :any_skip_relocation, big_sur:        "72cc03145f370116ab72ab831a21218e4391351ebea235104dfa0106bd2293e5"
    sha256 cellar: :any_skip_relocation, catalina:       "927a70b55b1cd7812f967f3eae31438a8194c3a3a60c68e76715f352fe8c4270"
    sha256 cellar: :any_skip_relocation, mojave:         "4aad224b7c74a73ebce37574e54a94102b7f2eb2ee60ab02768cec64c24a43bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cab09eff45b4f1d472312773d0b512d6984ca9e37d5acf2ef0442c4eb2f01e43"
  end

  depends_on "python@3.10"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/42/6e/549283c6f8b9fff54ee8bd35558eb51d3796b1f71509d3385011d9a8c857/rich-10.3.0.tar.gz"
    sha256 "a83bff83309687e1859c75b499879738b135d700738dd2721c22965497af05bd"
  end

  def install
    virtualenv_install_with_resources

    xy = Language::Python.major_minor_version Formula["python@3.10"].opt_bin/"python3"
    site_packages = "lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-name_that_hash.pth").write pth_contents
  end

  test do
    hash = "5f4dcc3b5aa765d61d8327deb882cf99"
    output = shell_output("#{bin}/nth --text #{hash}")
    assert_match "#{hash}\n", output
    assert_match "MD5, HC: 0 JtR: raw-md5 Summary: Used for Linux Shadow files.\n", output

    system Formula["python@3.10"].opt_bin/"python3", "-c", "from name_that_hash import runner"
  end
end
