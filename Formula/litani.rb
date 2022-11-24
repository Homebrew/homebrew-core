class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.27.0",
      revision: "2e96431038ef80001f291587def57fa5218d482b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "345510ac0f6a7246d8a1afafa5d4bf013c3a6df31719e7bac940e811796648ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09b731d24d17fa9019814a66c59795e6a3045f53ece5ca841b7a675b23e331c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15ff461fea3eb008929ad2dd4ea59f7e465551d1e392ff47df810cad80a35e12"
    sha256 cellar: :any_skip_relocation, ventura:        "3ce58a07493f813a922520af02cf195a37b4f4eb66ef084d655201ccac20e1a7"
    sha256 cellar: :any_skip_relocation, monterey:       "25814ed866dcfd89ca11d9a09b98d28f2abfb6121419cf0a6dc5f9b89c6d97d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "37e505d935452f93ee7c7ca7b56f70577bb98b494cf9b5d8973bab63a3808022"
    sha256 cellar: :any_skip_relocation, catalina:       "aca7bba81b938d4ee5301ed030e4f7d98975970850edda0faa64aa2301ba46b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f6c8b083732e2a18c1870ee990ca348372c87c53cc0dd2ef0ba4cdda43e2432"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "scdoc" => :build
  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "ninja"
  depends_on "python@3.10"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin"
    venv = virtualenv_create(libexec/"vendor", "python3.10")
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
    rm_rf libexec/"doc"
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
