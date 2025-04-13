class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.52.tar.gz"
  sha256 "60044c36bbb796d3638fe24fec0a9df0780a3d61f00186596055234b4c244817"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8448d1e6f78e147148cf8809e061ddcbe297a1a1c461e0667ff449694fa8af79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "557a26e2730c3129a0c236e6ad8068f93182a848353889b28f3b317a4328f243"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8bdae809691c77e08cad98a10713170a695a58c3b1827f2773b46c8f96709111"
    sha256 cellar: :any_skip_relocation, sonoma:        "db6384b46f60f95902434422d68143ddc9018704128b96ea4a4fc6f06a5e26e1"
    sha256 cellar: :any_skip_relocation, ventura:       "9ba66db42294bda2437903612532f7f5094f5d5026c3e46af00a3a913d71a225"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d0ef23bbb0ef0870d8d32f15af0bdd027e0e94667c13655287a18f979ffb211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee5fea63eb5e1e1934902ec0044ac5654627279386c56a9e486cddaed9a98d9e"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  def install
    feature_args = "els,full-repl,unicode,backtrace"
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", "--features", *feature_args, *std_cargo_args(root: libexec)
    pkgshare.install buildpath.glob(".erg/*")
    (bin/"erg").write_env_script(libexec/"bin"/"erg", ERG_PATH: pkgshare)
  end

  test do
    (testpath/"test.er").write <<~EOS
      print! "hello"
    EOS

    output = shell_output("#{bin}/erg lex #{testpath}/test.er")
    assert_equal "[Symbol print!, StrLit \"hello\", Newline \\n, EOF \u0000]\n", output

    output = shell_output("#{bin}/erg check #{testpath}/test.er")
    assert_match "\"hello\" (: {\"hello\"})", output

    assert_match version.to_s, shell_output("#{bin}/erg --version")
  end
end
