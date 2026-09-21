class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/ac/5e/c83be8d5beed742079976c2b2bd75f3505166e0ef5aa2ffe67cbced0a94a/graphviz2drawio-1.2.0.tar.gz"
  sha256 "75a4775dd975c932ff7e2bfa49cc5ec6c8f1dffe77a3b5b56d40ae3850af692b"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "76ebcb2599e39b0dee75e91439ec685ab77fce79884c8f89b9be91e93f734cac"
    sha256 cellar: :any, arm64_tahoe:       "a5b8da77f9ac1b15ec142d910f3284aa6960844f8f972664a5891d2ab405c79f"
    sha256 cellar: :any, arm64_sequoia:     "cd43d43baacba611bc3b5e8fccd181d5f28395dd070d7202d4d4ced9a1f0a495"
    sha256 cellar: :any, arm64_sonoma:      "7904d6b61f941b6ff4862eed05ae4efacd6814c96b2bc9bc7a1e6b39ca7d202f"
    sha256 cellar: :any, arm64_linux:       "b8747e50c2bcdd7ea02900158d8ff1138f4a97633e9f6ba84d5f40f97a4a8cdc"
    sha256 cellar: :any, x86_64_linux:      "40ca185dba6800cb5c84e3c7438435ba31408916624e00878ac59309027d459a"
  end

  depends_on "rust" => :build
  depends_on "graphviz"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/4f/03/14ba7e94e2a9107324b5435052a34c92df2637274343c26aa44361626b01/pygraphviz-2.0.tar.gz"
    sha256 "7cc6cfff4bfa6c1bf389cbbf72f5995a717c69de69c18763544c04b41181f59e"
  end

  resource "svg-path" do
    url "https://files.pythonhosted.org/packages/33/a0/4983cdedf62c3a1dd42b698813312fc51dd159983333fce9ec4189cd83a9/svg.path-6.3.tar.gz"
    sha256 "e937740a316a7fec86acd217ab6226e112f51328078524126bb7ea9dbe7b1ade"
  end

  def install
    # Work around pygraphviz source-build discovery and runtime paths for nonstandard prefixes.
    # https://github.com/pygraphviz/pygraphviz/issues/630
    if OS.linux?
      graphviz_prefix = formula_opt_prefix("graphviz")
      ENV["GRAPHVIZ_PREFIX"] = graphviz_prefix
      ENV.append "LDFLAGS", "-Wl,-rpath,#{graphviz_prefix}/lib/graphviz"
    end
    virtualenv_install_with_resources
  end

  test do
    assert_match "mxCell id=\"node1\"", pipe_output(bin/"graphviz2drawio", "digraph { a -> b }")

    assert_match version.to_s, shell_output("#{bin}/graphviz2drawio --version")
  end
end
