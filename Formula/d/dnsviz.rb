class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/50/33/de6ddf145bdb6c94ee25b33bc314af3bdbd15950c5a4647295da224ab58f/dnsviz-0.11.2.tar.gz"
  sha256 "ca136788bd868c03b1f2653575d899ffef41a016711655c0ee65f89c1bea3514"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "9c0fe85faca1c39f39a0f6f095674faaa5e38374887e827aadb1a66e78dfbd9b"
    sha256 cellar: :any, arm64_tahoe:       "d62abc01ab3f338c19d104ad364ed8b409341baf55695042e33d7e898e380de0"
    sha256 cellar: :any, arm64_sequoia:     "67f433fbbd71572f0863a2788216f95d5446667478919bec2d3782e086d5e9be"
    sha256 cellar: :any, arm64_linux:       "283453170a5296c8ce9cee0837a0977ddc6d011ac8f885b2e13fcfe0517cc139"
    sha256 cellar: :any, x86_64_linux:      "6e8f91c8af7a24a9de3abbe56e70754a3d7a7a5422f6b38d0b5072d82908cf13"
  end

  depends_on "bind" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for dnspython > uv_build > maturin
  depends_on "swig" => :build
  depends_on "json-c" => :test
  depends_on "cryptography" => :no_linkage
  depends_on "graphviz"
  depends_on "python@3.15"

  pypi_packages extra_packages: ["dnspython", "pygraphviz", "setuptools"]

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ef/4a/50822184bd67cc6493f0fb6a880749158fcd31ab3fa07409acfd91f9fc85/dnspython-2.9.0.tar.gz"
    sha256 "b44dc6b18f07a8b1c56676a19fbfdb5209415b046a9cece286baafa87ff3f7f1"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/01/f7/a82e7f47573168960ce7e2a6c937a084a14d58599fe2a48ea3cde8ca555b/pygraphviz-2.0.3.tar.gz"
    sha256 "e46818608638959ceabec66a36d2efc1d60b790a845f29705e403feecc7ee0c0"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "example-com-probe-auth", :test do
    url "https://raw.githubusercontent.com/dnsviz/dnsviz/refs/heads/master/tests/zones/unsigned/example.com-probe-auth.json"
    sha256 "6d75bf4e6289db41f8da6263aed2e0e8c910b8f303e4f065ec7d359997248997"

    livecheck do
      skip "Test fixture"
    end
  end

  def install
    # TODO: Remove when PyGraphviz discovers nonstandard Graphviz prefixes.
    # https://github.com/pygraphviz/pygraphviz/issues/630
    if OS.linux?
      graphviz_prefix = formula_opt_prefix("graphviz")
      ENV["GRAPHVIZ_PREFIX"] = graphviz_prefix
      ENV.append "LDFLAGS", "-Wl,-rpath,#{graphviz_prefix}/lib/graphviz"
    end
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.test? || r.name == "pygraphviz" }
    # Use Homebrew's SWIG instead of rebuilding it in pip's isolated environment.
    venv.pip_install resource("pygraphviz"), build_isolation: false
    venv.pip_install_and_link buildpath
  end

  test do
    resource("example-com-probe-auth").stage do
      system bin/"dnsviz", "probe", "-d", "0",
        "-r", "example.com-probe-auth.json",
        "-o", "example.com.json"
      system bin/"dnsviz", "graph", "-r", "example.com.json", "-Thtml", "-o", File::NULL
      system bin/"dnsviz", "grok", "-r", "example.com.json", "-o", File::NULL
      system bin/"dnsviz", "print", "-r", "example.com.json", "-o", File::NULL
    end
  end
end
