require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.21.0.tar.gz"
  sha256 "8580826b248ae1d268ea1439b05fcc53a7010a4bb64c4e240baabc20be6c3bcf"

  bottle do
    cellar :any_skip_relocation
    sha256 "f276861e6498567eb761b9ccb724e741280276971867b667f1b0c3a5f5a4b604" => :el_capitan
    sha256 "18fb28eb4efbcd299e50b3101905a02cd90119571c7064e8d2914e6134b55fc3" => :yosemite
    sha256 "9d7908ece4cf6196735762b437233218960b33ee24a8f5caac333cd330d0f58f" => :mavericks
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
