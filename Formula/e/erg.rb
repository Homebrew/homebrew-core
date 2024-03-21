class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.33.tar.gz"
  sha256 "71485b6f19a52509df5645f67d7e2982f39430e5e17719434ea661db4d9f836d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6025dcc27a8b953748e0cfb57cebcad7dd5f40db7c5fe145a2b46e633984d5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b054758bd62fa4565b54587a6317b7e4834c9edd34a3490591d57df91c527be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3526ac349cf10555bf3d43cb18595446bfbba1050335302b2de7236b9f8b6dc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a845da686b613e27eda95e6e0677062a728ffe5aa6be2708cccc91aac5fabcd"
    sha256 cellar: :any_skip_relocation, ventura:        "68729a569a22927d66665fa1949e1c4483afe31e3020451e870b7d7a9c709f56"
    sha256 cellar: :any_skip_relocation, monterey:       "b1e5b8823f0f1c4979841e96291fde48609cd25b82c0fc9606bfbee066ef231e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7b7e09ca3f2b0c9976c4ccade451864dc8d5aacf1eac98ea6177244c36266d2"
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
