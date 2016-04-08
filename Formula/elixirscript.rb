class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.18.0.tar.gz"
  sha256 "1c9518a61abc2b587bd392bdaecfce75e6c399e5c5e21d64ed818f340a25a0ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba05da26a6b8881204a99f68efe5c471af0c06e3c34030c9449e44a3bc63f778" => :el_capitan
    sha256 "b83a7ff7be1c83be931c9e9b38c6b4888fe1c0d3513cec855bc5d68e7a879807" => :yosemite
    sha256 "2af0d3128636e63856a0c822d09a2804397a1f4d96eb6da99653f0eb075dc8c6" => :mavericks
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
