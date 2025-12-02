class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.29.0",
      revision: "8002c240ef4f424039ed3cc32e076c0234d01768"
  license "Apache-2.0"

  bottle do
    rebuild 5
    sha256 cellar: :any,                 arm64_tahoe:   "9759632a6582af9013d067c4461d07a5cd713405b2325593dcbbcd80dba1dee5"
    sha256 cellar: :any,                 arm64_sequoia: "e90d4268066cfc34e1324f2b65fbc83ebd8b2c13727a8e5bb9fe2720fd7335bc"
    sha256 cellar: :any,                 arm64_sonoma:  "d3e1a4ef297c94137c6ee223fa246f89c45b11a2dd92a3778415efb923f8ec08"
    sha256 cellar: :any,                 sonoma:        "aa07f4bd06cfef36b6c1aeb00f0399dde3a5f2757905891ca77ba4ffaca0127e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "626ef7ddbb0b86a50f8f7f6e3f846afe918bb3820a26a4861e03186e1be97e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0331320a1a3ab0d6b7564b35460c0b455824aaadc7f9d0f757c73aee894e71c2"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "scdoc" => :build
  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "libyaml"
  depends_on "ninja"
  depends_on "python@3.14"

  pypi_packages package_name:   "",
                extra_packages: %w[jinja2 markupsafe pyyaml]

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin"
    venv = virtualenv_create(libexec/"vendor", "python3.14")
    venv.pip_install resources

    libexec.install Dir["*"] - ["test", "examples"]
    (bin/"litani").write_env_script libexec/"litani", PATH: "\"#{libexec}/vendor/bin:${PATH}\""

    cd libexec/"doc" do
      system libexec/"vendor/bin/python3", "configure"
      system "ninja", "--verbose"
    end
    man1.install libexec.glob("doc/out/man/*.1")
    man5.install libexec.glob("doc/out/man/*.5")
    man7.install libexec.glob("doc/out/man/*.7")
    doc.install libexec/"doc/out/html/index.html"
    rm_r(libexec/"doc")
  end

  test do
    system bin/"litani", "init", "--project-name", "test-installation"
    system bin/"litani", "add-job",
           "--command", "/usr/bin/true",
           "--pipeline-name", "test-installation",
           "--ci-stage", "test"
    system bin/"litani", "run-build"
  end
end
