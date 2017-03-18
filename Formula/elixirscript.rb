require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.27.0.tar.gz"
  sha256 "ba43efa73a2d0b8b29cfe50a5477f3ef37a7f370041fa7f7b359fd9cd140a305"

  bottle do
    cellar :any_skip_relocation
    sha256 "e11aeba951acb8d8622e5519fded5ee8b8555e15a56dfd43905b38c1cbef5495" => :sierra
    sha256 "3792443d5aa03cc42b787b8b1db075c73fc8a5e0caa8d11cf5f26fe8d824c879" => :el_capitan
    sha256 "a10c2741bc2b17e026ed579e3f3eceac53fb7a74dfe280334b41dd10af9f41fe" => :yosemite
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
