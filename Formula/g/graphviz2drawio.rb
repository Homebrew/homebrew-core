class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/ac/5e/c83be8d5beed742079976c2b2bd75f3505166e0ef5aa2ffe67cbced0a94a/graphviz2drawio-1.2.0.tar.gz"
  sha256 "75a4775dd975c932ff7e2bfa49cc5ec6c8f1dffe77a3b5b56d40ae3850af692b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fe47e62410931ff639ee09b7217977faf5881f6f3839ed0a698e4b0fc3fda32e"
    sha256 cellar: :any, arm64_sequoia: "05a4299f0717bab0a538793f0f9dceff150244943649d5400ef84a24e09b809c"
    sha256 cellar: :any, arm64_sonoma:  "b477129a226b94a0c9fd04a261593c0d269b86b4c384290121214a99a35eab25"
    sha256 cellar: :any, sonoma:        "3df7a2684d5d7e10ad11a9a1a83ecae879844b2493aaa5a35f92d5070e718a65"
    sha256 cellar: :any, arm64_linux:   "4b0869d6fb0d504dd997b4f231515019b1e09a4d2cee83728b08d798e06b23c4"
    sha256 cellar: :any, x86_64_linux:  "613681b5b56f2a81bd780c540822edcc43ead926b7e1bffe9277b41d29bcefb7"
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
