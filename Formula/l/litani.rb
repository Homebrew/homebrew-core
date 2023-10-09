class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.29.0",
      revision: "8002c240ef4f424039ed3cc32e076c0234d01768"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50a38bebf87464469449135d80e85aabf969e16240396dd778011c06f3546f88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43d0934af6a646890e091f7e81f3d42af5eafbbf9f97844643e1df7533407112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c3e02201c216f5c2eff2672663a3d3c3b45296a9d2a869da82befd903c4b234"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da931fdeb2a22f86a9149101b1483e6c8d2120ed831ed8e2a76b3bc551a0958b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f5d2bd61b05a84ec80e299a5a4af9ee19216082cd35a4d9513713ad27f48644"
    sha256 cellar: :any_skip_relocation, ventura:        "b3b022cb6e3626b9c9cd7ece12d6117aa328689a0f3bc0841e95f8e1094e4fae"
    sha256 cellar: :any_skip_relocation, monterey:       "441eb8324c4037d3621471a4d4b7ce6e8028b85ba474f7e359f428b6660c795b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdf62a5e11bb9bfb3b036129c875d2721193392157546ab2c3b4030a711fa014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fad432d35e3bd83d0fbc53e2fb2c181e4361d5a14f5e2b0e217bb5571e737e1"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "scdoc" => :build
  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "ninja"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
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
