class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.22.0",
      revision: "9ce9c61b406f0ad78a494cb4a8010546bc392c3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "974f05ee97ef95def637836cd4f328b20c3f8f2794fcf67003d10ffa5bf27e62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24f7719be167d1ae5fb2c596225a9da71737bb9c8207b1302493b7c09a35d2e0"
    sha256 cellar: :any_skip_relocation, monterey:       "45ad459474a8cc822591f76322ebddeaee944c1a3c8ea34ed168ae1bf28e3cdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae84e96a364fff69cb679e184cb1f530bb6f27e4ff527d6613403f5c44d2d9ab"
    sha256 cellar: :any_skip_relocation, catalina:       "b24663720a2d7145d8d9a84306e4c91f21be199bcc70aaf47b64da84dcb16d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06a28d5c9ac356fbdeff7ee254d63b97d639fe76943d5e510eeef2634ec2aa49"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "scdoc" => :build
  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "ninja"
  depends_on "python@3.9"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/39/11/8076571afd97303dfeb6e466f27187ca4970918d4b36d5326725514d3ed3/Jinja2-3.0.1.tar.gz"
    sha256 "703f484b47a6af502e743c9122595cc812b0271f661722403114f71a79d0f5a4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin"
    venv = virtualenv_create(libexec/"vendor", "python3")
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
