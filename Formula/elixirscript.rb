require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.20.0.tar.gz"
  sha256 "729da6d65c0ed764d8fcbb1313a811bd0cfdcec91e499192fc9d986544db40c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "f276861e6498567eb761b9ccb724e741280276971867b667f1b0c3a5f5a4b604" => :el_capitan
    sha256 "18fb28eb4efbcd299e50b3101905a02cd90119571c7064e8d2914e6134b55fc3" => :yosemite
    sha256 "9d7908ece4cf6196735762b437233218960b33ee24a8f5caac333cd330d0f58f" => :mavericks
  end

  depends_on "elixir" => :build
  depends_on "node" => :build

  def install
    system "mix", "local.hex", "--force"
    system "mix", "deps.get"
    system "npm", "install", *Language::Node.local_npm_install_args
    system "mix", "std_lib"
    system "mix", "clean"
    system "mix", "compile"
    system "mix", "dist"
    bin.install "elixirscript"
    prefix.install Dir["priv/*"], "LICENSE"
  end

  test do
    src_path = testpath/"Example.exjs"
    src_path.write <<-EOS.undent
      :keith
    EOS

    out_path = testpath/"dest"
    system "elixirscript", src_path, "-o", out_path

    assert File.exist?(out_path)
    assert_match("keith", (out_path/"Elixir.ElixirScript.Temp.js").read)
  end
end
