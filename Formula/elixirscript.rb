require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.27.0.tar.gz"
  sha256 "ba43efa73a2d0b8b29cfe50a5477f3ef37a7f370041fa7f7b359fd9cd140a305"

  bottle do
    cellar :any_skip_relocation
    sha256 "3865cc544f6d1005e530e9892e76de21e28d51cc90b2967bed11ab6d4533e025" => :sierra
    sha256 "5429d87159a90f8e3c831f4091066b2ebdb2ac25aa6ec76d5642baee25cee011" => :el_capitan
    sha256 "95b887cce43fbbdd208996cfe7dfe2be766b59ae63fe4c8ec5e756a96ba31fae" => :yosemite
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
