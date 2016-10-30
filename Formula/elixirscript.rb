require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.22.0.tar.gz"
  sha256 "371d114e9e6be7a7d944d4e4d191b379327e1a57c888a80d00f3d9374cef57b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "79d5db73b7a3f75e4948ce2312fc7dd9e405e6e16b9a131e97510b4d1e82878c" => :sierra
    sha256 "643108b4b01f6ccff7eb169c44384fe703c8172c5ac1ac4080347bc9526a3480" => :el_capitan
    sha256 "73e196bbaeb7c8c40c1623029743809424fa0e4af60265acb6326c8c0f952f39" => :yosemite
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
