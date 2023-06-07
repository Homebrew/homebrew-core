class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.28.0",
      revision: "00e2dda4e8ce2c6fb11e3904861e986af228099e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c7fd77b08d05387bfbb288f3ecaa9abfd71b0a937b6f66632fbf7bd9b16c107"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3412256f752e8dc3228bbab0034edbf90180795e746ba91fbf6433762607614"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc565ff6b94663f669f8ccbf3f0384842fa7b8c40f1dea86248f1923e83fce4e"
    sha256 cellar: :any_skip_relocation, ventura:        "9890059ce83d9d7e7b1106beea0e0424c266a90e4a069df8f8ee44091ae1cb90"
    sha256 cellar: :any_skip_relocation, monterey:       "0cae52fa2028e9a1056b603bb9d34d55e69495f4668bba9e5bfff09ebf576052"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f1e1ded52a763a982d3c0935fbd307f272370f09cdd13358b93968e7221482b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e9f6aac3af7a5f13b15f695ccd8460e1c85d50dea3081697c06a8eceebe43fb"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "scdoc" => :build
  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "ninja"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  # Support Python 3.11, remove on next release
  patch do
    url "https://github.com/awslabs/aws-build-accumulator/commit/632b58cbbcffec0f0b57fdb6ca92fa67d1e5656d.patch?full_index=1"
    sha256 "6fb6d8fe2c707691513cbaaba5b3ed582775fee567458d1b08b719d1fe0a768e"
  end

  patch do
    url "https://github.com/awslabs/aws-build-accumulator/commit/d189541fcbaad28649f489e6823c2c4ca2c6aa33.patch?full_index=1"
    sha256 "f3d79ea8ccf5ff8524a4da3495c8ffd0a2bd1099aaab1d8c52785ca80e13aee7"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin"
    venv = virtualenv_create(libexec/"vendor", "python3.11")
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
