class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.28.0",
      revision: "00e2dda4e8ce2c6fb11e3904861e986af228099e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "840aab2ed7faddc6a460dbd6779d0dd57a671782d6124c1e265bc69bb325c80e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38bcc7f59fb4e09286c802393ee3a0cab1e13168e050e250cb7b3705ca966d1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b965cba710b82f93033c8dfcbc3955242f63d32394722abec7723c58a2f66e28"
    sha256 cellar: :any_skip_relocation, ventura:        "dec2d86f60dfc8065829d314d62b45e5d6a6df39dcae7850407a876e43cce781"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b7a57c397359998446bea9d32e2c9f3ca6fdfff9143350f3a39a449c4d4703"
    sha256 cellar: :any_skip_relocation, big_sur:        "28eb692342a74464d4a1dbac3211f02882324255cc195a1b9ce91fcefcafa6dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "593989e982ac9c52813f316298d6605f81ca1b743c95847c5d1bca2b73e7b978"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "scdoc" => :build

  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "ninja"
  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
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
