require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.25.0.tar.gz"
  sha256 "b3c9f732d76de2375f1b2b11dbcbd8b907219061ff31fb004620e3793d38e0fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d8b193a2800a6d3a0de6bb51cf19d9cd56ca7f4da2e9720a556508c4a9b1865" => :sierra
    sha256 "03f053725fa0718078c46f99090ab4a353137e20d357942f88f48271c14a62c9" => :el_capitan
    sha256 "0e9c085a36d650a6defbab0a384fd77eee11c5642a3d9de1a4abd2fb36afd5ad" => :yosemite
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
