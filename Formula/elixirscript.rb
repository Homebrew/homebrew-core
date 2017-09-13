require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.28.0.tar.gz"
  sha256 "65899a2be6faafce4bccc1724416de2a5e9f9a4f6b4dc89ed7ab7a63f7ba5e2d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7a32effa9e406bf709279a2316b7fe5950de78d5d084650677f433d9e32170b" => :sierra
    sha256 "902dcc4ec62babaf0019e416d85e038d68fada64b7dc5be14304d16c99323a8e" => :el_capitan
    sha256 "81ce6e663fdd5f5c59cd7d7c7748019ddd4c2daa24a4dc7a081d63e1176a4020" => :yosemite
  end

  depends_on "elixir" => :build
  depends_on "node" => :build

  def install
    ENV["MIX_ENV"] = "prod"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get"
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    system "mix", "clean"
    system "mix", "compile"
    system "mix", "dist"
    system "mix", "test"
    system "npm", "test"

    ENV.delete("MIX_ENV")
    system "mix", "docs"

    bin.install "elixirscript"
    prefix.install Dir["priv/*"]
    doc.install Dir["doc/*"]
  end

  test do
    output = shell_output("#{bin}/elixirscript --elixir :keith")
    assert_match "Symbol.for('keith')", output
  end
end
