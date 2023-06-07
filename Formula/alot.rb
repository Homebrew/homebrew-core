class Alot < Formula
  include Language::Python::Virtualenv

  desc "Text mode MUA using notmuch mail"
  homepage "https://github.com/pazz/alot"
  url "https://github.com/pazz/alot/archive/0.10.tar.gz"
  sha256 "71f382aa751fb90fde1a06a0a4ba43628ee6aa6d41b5cd53c8701fd7c5ab6e6e"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/pazz/alot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cdc89be7f995438bdd714f6718acbd2fc5f90ff5e2c5e7e0cfb9b0f46e12b94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0ae5aed969d45e939f646c90119fd440e19b179e569ec937ac88611ebccc5a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62e87074af09ebeddef08123d59b8ccbf13abc2e896bb3350e37e76900a9cfe6"
    sha256 cellar: :any_skip_relocation, ventura:        "016bb81b78a4bff6e11fd7af9a59974e10fc74fd694b6e70c6800dd13c4b8d51"
    sha256 cellar: :any_skip_relocation, monterey:       "cdc22fc59e24c7c2f1ff306f3a2e6d6f71666d7b03f07f4f29950b31c7cfb461"
    sha256 cellar: :any_skip_relocation, big_sur:        "791bb9dcebb72f6a9eec467ed697a362aafc3f1e611be077c2a115c4cf2da35a"
    sha256 cellar: :any_skip_relocation, catalina:       "b2a3fc9bf1323700553e37941f2d3c2db4d00de34d815fc949072331c0f8c98f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67b829bcff2abe5428d6dbb11a6a59a0d3c81ff3f1e7b522cb11d847a08031da"
  end

  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "gpgme"
  depends_on "libmagic"
  depends_on "notmuch"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "Automat" do
    url "https://files.pythonhosted.org/packages/7a/7b/9c3d26d8a0416eefbc0428f168241b32657ca260fb7ef507596ff5c2f6c4/Automat-22.10.0.tar.gz"
    sha256 "e56beb84edad19dcc11d30e8d9b895f75deeb5ef5e96b84a467066b3b84bb04e"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/95/f1/207a0a478c4bb34b1b49d5915e2db574cadc415c9ac3a7ef17e29b2e8951/constantly-15.1.0.tar.gz"
    sha256 "586372eb92059873e29eba4f9dec8381541b4d3834660707faf8ba59146dfc35"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/86/42/9e87f04fa2cd40e3016f27a4b4572290e95899c6dce317e2cdb580f3ff09/incremental-22.10.0.tar.gz"
    sha256 "912feeb5e0f7e0188e6f42241d2f450002e11bbc0937c65865045854c24c0bd0"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/e2/be/3ea39a8fd4ed3f9a25aae18a1bff2df7a610bca93c8ede7475e32d8b73a0/mock-4.0.3.tar.gz"
    sha256 "7d3fbbde18228f4ff2f1f119a45cdffa458b4c0dee32eb4d2bb2f82554bac7bc"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "Twisted" do
    url "https://files.pythonhosted.org/packages/b2/ce/cbb56597127b1d51905b0cddcc3f314cc769769efc5e9a8a67f4617f7bca/Twisted-22.10.0.tar.gz"
    sha256 "32acbd40a94f5f46e7b42c109bfae2b302250945561783a8b7a059048f2d4d31"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  resource "urwidtrees" do
    url "https://files.pythonhosted.org/packages/43/e1/ca5cf122cf1121b55acb39a1fb7e9fb1283c2eb0dc75fca751eb8c16b2f9/urwidtrees-1.0.3.tar.gz"
    sha256 "50b19c06b03a5a73e561757a26d449cfe0c08afabe5c0f3cd4435596bdddaae9"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/38/6f/fbfb7dde38be7e5644bb342c4c7cdc444cd5e2ffbd70d091263b3858a8cb/zope.interface-5.5.2.tar.gz"
    sha256 "bfee1f3ff62143819499e348f5b8a7f3aa0259f9aca5e0ddae7391d059dce671"
  end

  def install
    virtualenv_install_with_resources

    # Add path configuration file to use notmuch CFFI bindings
    site_packages = Language::Python.site_packages("python3.11")
    pth_contents = "import site; site.addsitedir('#{Formula["notmuch"].opt_libexec/site_packages}')\n"
    (libexec/site_packages/"homebrew-notmuch2.pth").write pth_contents

    pkgshare.install Pathname("extra").children - [Pathname("extra/completion")]
    zsh_completion.install "extra/completion/alot-completion.zsh" => "_alot"

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["SPHINXBUILD"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"
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

    assert_predicate testpath/"out.log", :exist?, "out.log file should exist"
    assert_match "setup gui", (testpath/"out.log").read
  end
end
