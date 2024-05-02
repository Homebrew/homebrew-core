class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.35.tar.gz"
  sha256 "0572b183c00a24cee927206365680585472a74472e0fa63df4f795c2fb2f238e"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e4ab4d194f7692c9ad58d49375292550c8c7a32026986c142350c3c8083ca86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efe4dd11b922a1df305c73c55b6ad75edbcd31ce5ac64dc3d57b8ca6b41df7f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f1a36655beea06d9b52f238230ebe1c13f301160b25363f2093e380c736df1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "808fb40ac0d07a5af21fd6617bc42a3a2ec55422486140567c7483f0eb5737cf"
    sha256 cellar: :any_skip_relocation, ventura:        "565005440b6e9b625fd153f2aad59dfe666311e09ca15c0f141aa6a5c887d0e5"
    sha256 cellar: :any_skip_relocation, monterey:       "6538394a91f2a2d25fd1272793471a294a1fc85cbc32bd9f637f5cefaae60799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c19552810db4235dad06f217ebe02e784fe1acddf38c8b148fd210a6e602fd4"
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
