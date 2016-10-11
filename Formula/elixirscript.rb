require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.21.0.tar.gz"
  sha256 "8580826b248ae1d268ea1439b05fcc53a7010a4bb64c4e240baabc20be6c3bcf"

  bottle do
    cellar :any_skip_relocation
    sha256 "4243ede37038b43ff91c5c669cb4ef89aa61784d28f4b0e2290bb285a28917e3" => :sierra
    sha256 "bc42d5a2dba3a02c35436741bc9a3e5aaf79e75d9be04ddd20e115a092a6da72" => :el_capitan
    sha256 "3a0e04f52b69a4e9c852906439956b324cb11fe78534b5a72d1e2a9c6a00de4d" => :yosemite
    sha256 "349cb1b7acf6075a9ee5d3dddc42ed5aea179fd7162416c19e48a45f4436dc91" => :mavericks
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
