class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.53.tar.gz"
  sha256 "1e9c462f255b2438392267281d27fe576f4aeebbe8dd7233b618550709ae1db6"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e023ac2edc96a64a6018908035a57dae257571215a9c07638c51163412f17fb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ede4eb6b4dc1753b90e42e7f9c9e583e81f259eab1c6d651ab673706b79747eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fed24912d1f97f7e03ea7ed031f337c363d053d28e45b8ef52f831649a2c930"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d2dc59c970e2f7c5749a07e1fe8305b01b6f84223d6d44e1fd3b8e01d05ebb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "516605c356e210661c1ffa58b8820e302786a7abc3b3c54e320e428f80ef6661"
    sha256 cellar: :any_skip_relocation, ventura:       "d13936f69d0c3af87bf510fc4fb6cb44068cdbf3ea9409f390674145b5347402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebb138f3a99d1ca2d0ee80bbf068198cd920bdd75854f92436fed724fcf79df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "788d1c686b0a1dbc909294bc26e6057dc95aaed023fc3058b9674c31a9cdd8bb"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  def install
    feature_args = "els,full-repl,unicode,backtrace"
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", "--features", *feature_args, *std_cargo_args(root: libexec)
    pkgshare.install buildpath.glob(".erg/*")
    (bin/"erg").write_env_script(libexec/"bin/erg", ERG_PATH: pkgshare)
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
