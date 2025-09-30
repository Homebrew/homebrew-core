class Oakc < Formula
  desc "Portable programming language with a compact intermediate representation"
  homepage "https://github.com/adam-mcdaniel/oakc"
  url "https://static.crates.io/crates/oakc/oakc-0.6.1.crate"
  sha256 "1f4a90a3fd5c8ae32cb55c7a38730b6bfcf634f75e6ade0fd51c9db2a2431683"
  license "Apache-2.0"
  head "https://github.com/adam-mcdaniel/oakc.git", branch: "develop"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "60abd2db575988443d770ae177888cff9366de42bbe23c1da3fede13903385c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "07e3a3b23965b457f71c6938c55dd7dfcccffc666746863345e301f4888a4f13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7dda2bb361b0d013dae148630eb1c19a884bec2f3cec498681777f1355a4963"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2027a21cc9a6b104b4f5f28b0b75127116063abf32282890258db85b1f5c0fd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cdabb01c215dce0ca881f17a57c5426451fe6227f857bc9d935c23699ed31c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ecb4eb764030b55cb485cdd0f28343b65bf2a93de1f0c4ce4ba633e80fafd76"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a1feacc47d0b0117e8d5cde8685f72fc1ac7052d044a94f70583fc7152039d3"
    sha256 cellar: :any_skip_relocation, ventura:        "731ae9848fe6b0b63c6f4841399817bc2f310d806196d5e1a54220f85223f28a"
    sha256 cellar: :any_skip_relocation, monterey:       "57b18008429add80e4fdd436cc10091e9563e3d4c01f76f9429d146b49d17184"
    sha256 cellar: :any_skip_relocation, big_sur:        "df01ac42a1ff0632e6aebd2cd10f97d14631b5221556a667b71e6b61664a07e6"
    sha256 cellar: :any_skip_relocation, catalina:       "782964257658eba472afbe784511f772a4a84e951c582a5a57546cb682bb0b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "eaa3710811313c7fa1f91eb0e19c56d530b5eaf226649fcacb1348639bf130b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ef60b48d23e35832e2d6b65a2c503ff72f88c6d5ced38a5dad9642b2147d642"
  end

  depends_on "rust" => :build

  conflicts_with "oak", because: "both install `oak` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "examples"
  end

  test do
    system bin/"oak", "-c", "c", pkgshare/"examples/hello_world.ok"
    assert_equal "Hello world!\n", shell_output("./main")
    assert_match "This file tests Oak's doc subcommand",
                 shell_output("#{bin}/oak doc #{pkgshare}/examples/flags/doc.ok")
  end
end
