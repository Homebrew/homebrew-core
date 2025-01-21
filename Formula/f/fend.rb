class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "330ca6ca5fcb4410fe75caeab0d77b0b112a355ec2a5d5848dffb0a7a7a2e7a7"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a895b4ac98b099dacb311c238bcf5cdf860f823b6ddc70423224be74f290fe0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1905a8703a78bf4602a102c89aeb3578c2b1576bcd9a106c06153911ff0ae88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6621ae3e58ba667e556da05e943ae0ec4608d3f520081c523e98287d8df45222"
    sha256 cellar: :any_skip_relocation, sonoma:        "f068df89baada7957d393c260bc21f97bad06bfe7d22ae2ad6eb45941501d8e1"
    sha256 cellar: :any_skip_relocation, ventura:       "4e08534e87506e9af4bd106244689b2022496593b167a16b188403d79777cb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1408db401afb16f2b2220852e15250f2d35ceb5688902f975f7453ffc716e84"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
