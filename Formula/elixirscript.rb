require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.25.0.tar.gz"
  sha256 "b3c9f732d76de2375f1b2b11dbcbd8b907219061ff31fb004620e3793d38e0fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "e65990bf7c910dd1b485615d3b499732bdcee07b402afddc7bf538c7e15c7914" => :sierra
    sha256 "5a110112a9a2996ff0d1fa1c0f7ec45466ec94546857ef0a4853a8d1e6791e61" => :el_capitan
    sha256 "5b6b760eb8749b5b1db5c0cc78de3df231f807bfda7147582eeded2a13b42d40" => :yosemite
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
