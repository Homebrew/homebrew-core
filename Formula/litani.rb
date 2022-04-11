class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.23.0",
      revision: "8b042ac172f91815def223a247c904621c22fd1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4af379d68de0dea37f3d1c2ec56f71fb81e3f92668942e4564562d982682a0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5bc092d1b915cf33d0b0bbc422eb84d11c34997236d613ea4c8866a5b319bfb"
    sha256 cellar: :any_skip_relocation, monterey:       "4ff594e0e6af4fff91dae0c1074432fc83dbf7da5e45d739c6550255f018ac7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "37e8bd54c823fa354f6f3886c63599dd93241c255592d714eb6f568eaa229d54"
    sha256 cellar: :any_skip_relocation, catalina:       "4020b3dd5c0aefe847ec20bb1381ca28c5f67023c791f6adf5276ee13b0eb2b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf129053c3bda5214580007be201ea60d30ff22ae0bebd0b55281bddcbf39023"
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
