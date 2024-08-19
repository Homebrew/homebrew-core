class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "2f52729dee2e775c1adc52879a95429dd00748fe183df0f744f763b7f0d2aedf"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ac2d93d1108b73a9b83d03f90c55901a7732fc55e16e72463f266758eed9a8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29b629a46d3d400a37884bc354128e1dbc6fb525beaa91e7e7225196f3d58321"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a0ddfba6b074c9481d97a94efdb50b9a1af8288ef8657d553976880b89d9479"
    sha256 cellar: :any_skip_relocation, sonoma:         "09a5c2e47bf763a920914e1b80899bf1eb41ab099013799d060a1825f0e4ccae"
    sha256 cellar: :any_skip_relocation, ventura:        "c4bd219849793ebd7505ecc904ecf13665b03b298420d9c0a191420bc33f3d4d"
    sha256 cellar: :any_skip_relocation, monterey:       "5cda829a22b4fd0db8ac940f920d95e1df1ab143291347f90947ac7e2261c121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "992ed6f0fd44e737f6dd203b0c09a667c2c799889b4c280282198f94c84a6417"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
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
