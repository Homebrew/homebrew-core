class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.29.0",
      revision: "8002c240ef4f424039ed3cc32e076c0234d01768"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:  "783a2098086de5ae5bd6da1c2861405a9f9e6c81d39b610a588303b35afa5d32"
    sha256 cellar: :any,                 arm64_ventura: "335b32520084699755377ea966edd1110db54ce778add5be4c3c3f1a15ea696e"
    sha256 cellar: :any,                 sonoma:        "5e8d434b3d2fb389ad937ac3e97aba8896c9e1e99ed3d1537d5e3daa03ea3e50"
    sha256 cellar: :any,                 ventura:       "a548833f41ce2331f2bec2a29b70e93d51fe934afd5344b339e2967372233c0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1826fff1a8601653ed3cf9a4dd461f98650705be353ebea060a0f583e0826ab"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "scdoc" => :build
  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "libyaml"
  depends_on "ninja"
  depends_on "python@3.13"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin"
    venv = virtualenv_create(libexec/"vendor", "python3.13")
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
