require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.23.3.tar.gz"
  sha256 "8165b61a7521f9095d8a601fe2b7026fc00f906c59a8d85b009044fb4c553c20"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb155f0c96c26e55fed5faa23c94e7f47c57c75031e8b82ebd89b8c91a2df66f" => :sierra
    sha256 "a2fe9d4a767685b58b079d09f2b7e267d530e9d804cd893c4977687a9a165b6d" => :el_capitan
    sha256 "4dc6f6b15b3f1e6eab09a7ccf00e10daac5329ac2b6891e7205ae7579f6e23a2" => :yosemite
  end

  depends_on "elixir" => :build
  depends_on "node" => :build

  def install
    ENV["MIX_ENV"] = "prod"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get"
    system "npm", "install", *Language::Node.local_npm_install_args
    system "mix", "std_lib"
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
    output = shell_output("#{bin}/elixirscript -ex :keith")
    assert_equal "Symbol.for('keith')", output.strip
  end
end
