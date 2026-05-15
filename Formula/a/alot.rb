class Alot < Formula
  include Language::Python::Virtualenv

  desc "Text mode MUA using notmuch mail"
  homepage "https://github.com/pazz/alot"
  url "https://github.com/pazz/alot.git",
      tag:      "v0.12",
      revision: "40a190f4c5f18c1283fdb3186393c4a778f865a5"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/pazz/alot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b09b4a324b9627c7afa4787f4bd2f69ec2acf1bb431dfb9a062a810da4e20124"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81aee5384926ec83620d4fe1563494a7505a6fc2f957f85cdf9beac1c7e555ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "696a8b37c3fa9e45d6d586e5cb462ca37bd36499125506356c4d98b016fe58fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "383ee958a3148a1d7395b90930ef56d91ab54f6951c8c70290146e98b3b9b9d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62802cacdbe0a702e685c4ff5e5184ff6037b0fe315048503c7f5955ba56fe93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0445ee5a5b0e55293118cd895e94eb8d73473fb32afe92dae23bdca378b2c22"
  end

  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "gpgmepy" => :no_linkage
  depends_on "libmagic" => :no_linkage
  depends_on "notmuch"
  depends_on "python@3.14"

  # Dependencies include non-PyPI packages so cannot use Homebrew's default resolver
  pypi_packages package_name:   "",
                extra_packages: %w[configobj python-magic standard-mailcap twisted urwid urwidtrees]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/e3/0f/d40bbe294bbf004d436a8bcbcfaadca8b5140d39ad0ad3d73d1a8ba15f14/automat-25.4.16.tar.gz"
    sha256 "0017591a5477066e90d26b0e696ddc143baafd87b588cfac8100bc6be9634de0"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/ef/3c/82e84109e02c492f382c711c58a3dd91badda6d746def81a1465f74dc9f5/incremental-24.11.0.tar.gz"
    sha256 "87d3480dbb083c1d736222511a8cf380012a8176c2456d01ef483242abbbcf8c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "standard-mailcap" do
    url "https://files.pythonhosted.org/packages/53/e8/672bd621c146b89667a2bfaa58a1384db13cdd62bb7722ddb8d672bf7a75/standard_mailcap-3.13.0.tar.gz"
    sha256 "19ed7955dbeaccb35e8bb05b2b5443ce55c1f932a8cbe7a5c13d42f9db4f499a"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/db/97/6e9beb1e78247ae6dc34114f27d538cf2cb183c4afcd3609dfdf2b0439c8/twisted-26.4.0.tar.gz"
    sha256 "dbfd0fe1ee409d0243fdd7a6a6ff14f4948cec1fd78e0376291f805e1501fae9"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/1c/09/afbd44c7c57b1124d94ffe6321154798b816bd09c00e0aaabb701583a1c8/urwid-4.0.0.tar.gz"
    sha256 "58ddc5c65eb3109b69e2e95469553f9f86070645cc1b553d6ee3fe8dbac2e0ba"
  end

  resource "urwidtrees" do
    url "https://files.pythonhosted.org/packages/9f/a9/d98891fd9c143fb42277cb9a396aad5db76ed64bf747cb32ac19baaf04fa/urwidtrees-1.0.4.tar.gz"
    sha256 "e693a0292e03092ba00abcfa2fa2537233be3696c4313d285b1eff94a4a45d4d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/9f/65/34a6e6e4dfa260c4c55ee02bb2fc53625e126ff0181485286cf0c9d453d6/zope_interface-8.4.tar.gz"
    sha256 "9dbee7925a23aa6349738892c911019d4095a96cff487b743482073ecbc174a8"
  end

  # Check for any changes needed in `extra_packages`
  def check_pypi_extra_packages
    pypi_deps = File.read("pyproject.toml")[/^dependencies\s*=\s*\[\s*"([^\]]*)"\s*,?\s*\]/, 1]
    odie "Failed to parse PyPI dependencies from pyproject.toml!" if pypi_deps.nil?

    pypi_deps = pypi_deps.split(/"\s*,\s*"/).map { |pypi_dep| pypi_dep[/^([a-z0-9._-]+)/i, 1] }
    pypi_deps -= %w[gpg notmuch2]
    pypi_deps.sort!
    odie "Parsed extra_packages: #{pypi_deps.inspect}" if pypi_packages_info.extra_packages != pypi_deps
  end

  def install
    check_pypi_extra_packages if build.stable?
    venv = virtualenv_install_with_resources

    pkgshare.install Pathname("extra").children - [Pathname("extra/completion")]
    zsh_completion.install "extra/completion/alot-completion.zsh" => "_alot"

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["SPHINXBUILD"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"
    ENV.prepend_path "PYTHONPATH", venv.site_packages
    cd "docs" do
      system "make", "pickle"
      system "make", "man", "html"
      man1.install "build/man/alot.1"
      doc.install Pathname("build/html").children
    end
  end

  test do
    (testpath/".notmuch-config").write <<~EOS
      [database]
      path=#{testpath}/Mail
    EOS
    (testpath/"Mail").mkpath
    system Formula["notmuch"].bin/"notmuch", "new"

    require "pty"
    PTY.spawn(bin/"alot", "--logfile", testpath/"out.log") do |_r, _w, pid|
      sleep 10
      Process.kill 9, pid
    end

    assert_path_exists testpath/"out.log", "out.log file should exist"
    assert_match "setup gui", (testpath/"out.log").read
  end
end
