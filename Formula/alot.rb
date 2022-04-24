class Alot < Formula
  include Language::Python::Virtualenv

  desc "Text mode MUA using notmuch mail"
  homepage "https://github.com/pazz/alot"
  url "https://github.com/pazz/alot/archive/0.10.tar.gz"
  sha256 "71f382aa751fb90fde1a06a0a4ba43628ee6aa6d41b5cd53c8701fd7c5ab6e6e"
  license "GPL-3.0-only"
  head "https://github.com/pazz/alot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c79ff668ad0dbd660487733211ac380e97ae7e67cf211ef559be687c07f027d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f9ba3f7cc0858982386261853661c35eeaf4f0ecf928033345f5cf84005dcc7"
    sha256 cellar: :any_skip_relocation, monterey:       "4ae10d58fe370c3f27a5002c2a08c9aecbd107561ea8b302b2e75eefdc618a42"
    sha256 cellar: :any_skip_relocation, big_sur:        "96603eb0e2c1ff9195d760a15a5892f8b325b05ef504874ebc2c477d06bf4e99"
    sha256 cellar: :any_skip_relocation, catalina:       "9957fe31c30e665b47efd1150e90288fc91f9a00fd0298d1a8e0e0d7dcfaffbe"
    sha256 cellar: :any_skip_relocation, mojave:         "182143fbad21974b42e94c8432c80e395e53eeb7f0bbccffd36e687b67081c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b19f738d69314b171068f4318f1516c7351e76a9ce11f06156af0e49db6b4de0"
  end

  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "gpgme"
  depends_on "libmagic"
  depends_on "notmuch"
  depends_on "python@3.9"
  depends_on "six"

  resource "Automat" do
    url "https://files.pythonhosted.org/packages/80/c5/82c63bad570f4ef745cc5c2f0713c8eddcd07153b4bee7f72a8dc9f9384b/Automat-20.2.0.tar.gz"
    sha256 "7979803c74610e11ef0c0d68a2942b152df52da55336e0c9d58daf1831cbdf33"
  end

  resource "Twisted" do
    url "https://files.pythonhosted.org/packages/fb/1e/fffa0d45da0ed2998e4d7f121621f2de68c51153fbbab23e63901cf859f4/Twisted-22.4.0.tar.gz"
    sha256 "a047990f57dfae1e0bd2b7df2526d4f16dcdc843774dc108b78c52f2a5f13680"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
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
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/4f/c5/430765c697afc217c8491785de321a21fa4d983dda14bcd82feb965b0593/incremental-21.3.0.tar.gz"
    sha256 "02f5de5aff48f6b9f665d99d48bfc7ec03b6e3943210de7cfc88856d755d6f57"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/e2/be/3ea39a8fd4ed3f9a25aae18a1bff2df7a610bca93c8ede7475e32d8b73a0/mock-4.0.3.tar.gz"
    sha256 "7d3fbbde18228f4ff2f1f119a45cdffa458b4c0dee32eb4d2bb2f82554bac7bc"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/f7/46/fecfd32c126d26c8dd5287095cad01356ec0a761205f0b9255998bff96d1/python-magic-0.4.25.tar.gz"
    sha256 "21f5f542aa0330f5c8a64442528542f6215c8e18d2466b399b0d9d39356d83fc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/fe/71/1df93bd59163c8084d812d166c907639646e8aac72886d563851b966bf18/typing_extensions-4.2.0.tar.gz"
    sha256 "f1c24655a0da0d1b67f07e17a5e6b2a105894e6824b92096378bb3668ef02376"
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
    url "https://files.pythonhosted.org/packages/ae/58/e0877f58daa69126a5fb325d6df92b20b77431cd281e189c5ec42b722f58/zope.interface-5.4.0.tar.gz"
    sha256 "5dba5f530fec3f0988d83b78cc591b58c0b6eb8431a85edd1569a0539a8a5a0e"
  end

  def install
    virtualenv_install_with_resources

    # Add path configuration file to use notmuch CFFI bindings
    site_packages = Language::Python.site_packages("python3")
    pth_contents = "import site; site.addsitedir('#{Formula["notmuch"].opt_libexec/site_packages}')\n"
    (libexec/site_packages/"homebrew-notmuch2.pth").write pth_contents

    pkgshare.install Dir["extra/*"] - %w[extra/completion]
    zsh_completion.install "extra/completion/alot-completion.zsh" => "_alot"

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["SPHINXBUILD"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"
    cd "docs" do
      system "make", "pickle"
      system "make", "man", "html"
      man1.install "build/man/alot.1"
      doc.install Dir["build/html/*"]
    end
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    system Formula["notmuch"].bin/"notmuch", "new"

    begin
      pid = fork do
        $stdout.reopen("/dev/null")
        $stdin.reopen("/dev/null")
        if OS.mac?
          exec "script", "-q", "/dev/null", bin/"alot", "--logfile", testpath/"out.log"
        else
          exec "script", "-q", "/dev/null", "-e", "-c", "#{bin}/alot --logfile #{testpath}/out.log"
        end
      end
      sleep 10
    ensure
      Process.kill 9, pid
    end

    assert_predicate testpath/"out.log", :exist?, "out.log file should exist"
    assert_match "setup gui", File.read(testpath/"out.log")
  end
end
