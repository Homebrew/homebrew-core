class Alot < Formula
  include Language::Python::Virtualenv

  desc "Text mode MUA using notmuch mail"
  homepage "https://github.com/pazz/alot"
  url "https://github.com/pazz/alot.git",
      tag:      "v0.12",
      revision: "40a190f4c5f18c1283fdb3186393c4a778f865a5"
  license "GPL-3.0-only"
  revision 3
  head "https://github.com/pazz/alot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5fe67b91d2ae31393ef57e24accf66529f585675e0e5586141f5de0f3aeeaac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1293a542497a8886747637df81c82f1f1c0622efd2a37e55f5ef6170fa994932"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a7de9a12c130b5cdf16c84a82abb2367b48f7ad20d6bab032b5ee771789d97e"
    sha256 cellar: :any,                 arm64_linux:       "d2e0907e2d687d90c307199bd105d0da7bb67490b75cc3c8dd4b4f622c2179f5"
    sha256 cellar: :any,                 x86_64_linux:      "2f3f6e9cd7ead4fc5ba3063c15226918cb306c4c29abe89351870353870d4dff"
  end

  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "gpgmepy" => :no_linkage
  depends_on "libmagic" => :no_linkage
  depends_on "notmuch"
  depends_on "python@3.15"

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
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/ef/3c/82e84109e02c492f382c711c58a3dd91badda6d746def81a1465f74dc9f5/incremental-24.11.0.tar.gz"
    sha256 "87d3480dbb083c1d736222511a8cf380012a8176c2456d01ef483242abbbcf8c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
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
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/3a/df/eb5dcbdf1638c38618096382b4a30b0423ed7d2aac97fd9469b51d6de43f/urwid-4.2.5.tar.gz"
    sha256 "a1fea3a551953fae4e6b727536334233bbb8b88c45230bc91d9751b402a8c16d"
  end

  resource "urwidtrees" do
    url "https://files.pythonhosted.org/packages/9f/a9/d98891fd9c143fb42277cb9a396aad5db76ed64bf747cb32ac19baaf04fa/urwidtrees-1.0.4.tar.gz"
    sha256 "e693a0292e03092ba00abcfa2fa2537233be3696c4313d285b1eff94a4a45d4d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/26/39/a8481b926e42c44a6fcc670904f8251469ec42edbff1ba066719ca1e7fb4/zope_interface-8.6.tar.gz"
    sha256 "b40ef9b4873afb5d0dec02b8d2dfde1cf18c72337b60c99cb735961e0bac05c0"
  end

  # Python 3.15 removed `glob.glob1`
  patch do
    url "https://github.com/pazz/alot/commit/1632613bf03a20d0d81b6e1cb0e5b8fc96e6c16e.patch?full_index=1"
    sha256 "4f4826967eaae447aca7fae399fcc4e89af37f14bc8bf5a89aeba752471d743e"
    type :backport
    resolves "https://github.com/pazz/alot/pull/1713"
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
    ENV["SPHINXBUILD"] = formula_opt_bin("sphinx-doc")/"sphinx-build"
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
    system formula_opt_bin("notmuch")/"notmuch", "new"

    require "pty"
    PTY.spawn(bin/"alot", "--logfile", testpath/"out.log") do |_r, _w, pid|
      sleep 10
      Process.kill 9, pid
    end

    assert_path_exists testpath/"out.log", "out.log file should exist"
    assert_match "setup gui", (testpath/"out.log").read
  end
end
