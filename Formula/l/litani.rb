class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.29.0",
      revision: "8002c240ef4f424039ed3cc32e076c0234d01768"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c049c17c3e114808bd2bac7bf081416c7f1fe5e6b5c9a584ad6e8425d763f72e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc5aab5e6411a679502c223537902f34db78b0b1c9c253b97b23f5e7d6e23507"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "687c6614ae08dd31c69d555cd23a1e43253e5915997639c64b850e936c3d1af3"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d3f4c50532a9ad6d422345e1cb9ea28b265bde75def265a8db42b1d2c36003a"
    sha256 cellar: :any_skip_relocation, ventura:        "f094c8bdf88342917a408022c5060bae66311df2fb5a5cff5d934e7206f80f3f"
    sha256 cellar: :any_skip_relocation, monterey:       "8259fd4263a2c6ff8ce216f17d6562ce8fe50c8fa3535942eb119b7ca9f18197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e26ca6714f5c7afdc1cb3d7ab9a0fa3eec2f2624e9dd2ba525ec75ec6f9c2de"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "scdoc" => :build
  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "ninja"
  depends_on "python-markupsafe"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin"
    venv = virtualenv_create(libexec/"vendor", "python3.12")
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
