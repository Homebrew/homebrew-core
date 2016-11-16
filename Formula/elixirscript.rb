require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.23.1.tar.gz"
  sha256 "1669d6ef4833146f4167288b7f4a144e00aa870098c99d6bfad74e99a111836d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d541e3035af69739e09d20da8aa8e8162e56cc6ff01e60d02e805c2d49a91e34" => :sierra
    sha256 "184944daea288703afaa62547af2beb88f19d937729d4fd484138933fe3f2452" => :el_capitan
    sha256 "e7447130f79c2632b35fe0ad3d3742e71c4ed06086b435941a873c98ab34c116" => :yosemite
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
