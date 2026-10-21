class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.29.0",
      revision: "8002c240ef4f424039ed3cc32e076c0234d01768"
  license "Apache-2.0"

  bottle do
    rebuild 6
    sha256 cellar: :any, arm64_golden_gate: "b1f3b9ffe85fe744c934841f1d9c8af12250c12ed4931b394efee0bec76f684d"
    sha256 cellar: :any, arm64_tahoe:       "5511b337ee941ff7964dbf81b151a23600f6c057badb61b0b664d29383411c8f"
    sha256 cellar: :any, arm64_sequoia:     "230060a4d766996de02ae31cd796174e22ad697f6dd4f9df10714eae9e5f84fd"
    sha256 cellar: :any, arm64_linux:       "9b6ec1bedbab0cacebdd84f25017d8cec7be81239639d7878bcdb69e8daeeb36"
    sha256 cellar: :any, x86_64_linux:      "bb55557af53237e93e02a2aa4ae1838060bd5b2410626c9d8510a57ccf335e68"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "libyaml"
  depends_on "ninja"
  depends_on "python@3.15"

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

  # Not compatible with scdoc 1.11.5
  # TODO: replace with Homebrew formula
  resource "scdoc" do
    url "https://git.sr.ht/~sircmpwn/scdoc/archive/1.11.4.tar.gz"
    sha256 "e1a9c2000f855123a1a50c8f897073e0ee95fc41787431efe3864c2f1c2e7092"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin"
    venv = virtualenv_create(libexec/"vendor", python3)
    venv.pip_install resources.reject { |r| r.name == "scdoc" }

    libexec.install Dir["*"] - ["test", "examples"]
    (bin/"litani").write_env_script libexec/"litani", PATH: "\"#{libexec}/vendor/bin:${PATH}\""

    resource("scdoc").stage do
      system "make", "LDFLAGS=#{ENV.ldflags}", "PREFIX=#{buildpath}/scdoc"
      system "make", "install", "PREFIX=#{buildpath}/scdoc"
      ENV.append_path "PATH", buildpath/"scdoc/bin"
    end

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
