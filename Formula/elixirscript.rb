class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.18.0.tar.gz"
  sha256 "1c9518a61abc2b587bd392bdaecfce75e6c399e5c5e21d64ed818f340a25a0ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "b83fc14f0a1ae04e71e81dd8e447a98ad786ed3ce8668b3edd6bfb4c2a7e6fef" => :el_capitan
    sha256 "49bf0bfda2209e4dd6b12cb83452972142fd3154248aa8917321eaa894acc40b" => :yosemite
    sha256 "719ff0d2ef8d0d799e885bc9d842303eaba2a368dadc2e04702bd3b430a000b6" => :mavericks
  end

  depends_on "elixir" => :build
  depends_on "node" => :build

  def install
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"

    system "mix", "local.hex", "--force"
    system "mix", "deps.get"
    system "npm", "install"
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
