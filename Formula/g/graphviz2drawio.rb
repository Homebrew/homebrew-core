class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/ac/5e/c83be8d5beed742079976c2b2bd75f3505166e0ef5aa2ffe67cbced0a94a/graphviz2drawio-1.2.0.tar.gz"
  sha256 "75a4775dd975c932ff7e2bfa49cc5ec6c8f1dffe77a3b5b56d40ae3850af692b"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "49f7844247d564318b3fcfb31fb67116a79f0efae17318889d5d77aa43c59b9d"
    sha256 cellar: :any, arm64_tahoe:       "621009f437e1b4249c4586c858ff1aa6e958cff04b966b46a09c52a894c9cb59"
    sha256 cellar: :any, arm64_sequoia:     "82ed2505d04133f3714dda02d2f4b28a79c7103f4cd654a7e5b05eacbb184c1f"
    sha256 cellar: :any, arm64_linux:       "3a7947a538b4d60a4dd5ec4ce3da01c4c421ebaa8ecb0d930edc3f953ebbb090"
    sha256 cellar: :any, x86_64_linux:      "0e44fa02f94f61b0d0e57746f1fdb8de88931e421b693fa5080e26b5ecbd0a5a"
  end

  depends_on "rust" => :build
  depends_on "graphviz"
  depends_on "python@3.15"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/01/f7/a82e7f47573168960ce7e2a6c937a084a14d58599fe2a48ea3cde8ca555b/pygraphviz-2.0.3.tar.gz"
    sha256 "e46818608638959ceabec66a36d2efc1d60b790a845f29705e403feecc7ee0c0"
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
