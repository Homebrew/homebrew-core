class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://watchexec.github.io/#cargo-watch"
  url "https://github.com/watchexec/cargo-watch/archive/refs/tags/v8.5.2.tar.gz"
  sha256 "850b8de75c618fa1fcf5e2d56a6b2477e7224fbdfa793f5b5f30b31bf63fb358"
  license "CC0-1.0"
  head "https://github.com/watchexec/cargo-watch.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3318da9407a905cf94551b8812a3cf2b12e63f018dde893dba997ec4472b8246"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e474cca8cbb79931dce5e0047737d60144ca6d1341b28cdea378ed5ba17d90be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1765bb6293864b0bc25827614844ec2e4fa84c0a341bf84af5991bc41e1f8185"
    sha256 cellar: :any_skip_relocation, sonoma:         "a61abf4a1ea15fa1e97e63fb2bca63c3a99e90bb790e201d7a5b37feee080481"
    sha256 cellar: :any_skip_relocation, ventura:        "c3f3037dcb846689da3563de03aed6d3feff95641cfcd958195863c702ac09ca"
    sha256 cellar: :any_skip_relocation, monterey:       "6a9e0069d4f6a58dbfb6b1d928781e2e027a51b5572aba1f57700a1b5ee37748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1cf8b1113d8985e44bb87f94d5bfc34ff80acc454c2cfa478526afc31ae163a"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: project root does not exist", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
