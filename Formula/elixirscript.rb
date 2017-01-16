require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.24.0.tar.gz"
  sha256 "9b4b9b04328b230431567add8a3a1766dec40a49f8c7c3352dbd48bb1ea71a45"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef2877188dec7d9155c82f30c445ff9234831b3c25a746a409d82a2386811497" => :sierra
    sha256 "b2117b476a7102b1fc7dddf8e318b127431afdca5b1de3c67c1f5a29a3775456" => :el_capitan
    sha256 "ee87f93312270825e58757ad9471625e3dc9a6196a1ac0c159953498015c235b" => :yosemite
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
