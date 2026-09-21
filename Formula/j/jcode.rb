class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v0.86.0.tar.gz"
  sha256 "5d04516cc833e1b7684143a2d92d458766e94d247580b61f96179615d9e90a3d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80f0f6232bb34719f5a70834452c48aa72861e5038e06f731ab0e70eefec19c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e82e5ca781617354d65201cca1750ba0e091c21ce93ecff0d9dc181c600bba8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26e25747871a8d291529b7a64cf664cb69a9b0f251938e6a0de630a4d6866f9a"
    sha256 cellar: :any,                 arm64_linux:       "d03c344a6f4aed5e04712f0212ff0459600125a1ee11dc52603bb5faad7cbc0f"
    sha256 cellar: :any,                 x86_64_linux:      "4a8cd0588ad5fcf740f3fafc6b8ccb51e04111e291d8880a89501eb6ed33e771"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access! :build

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    # Disable background auto-update by default
    inreplace "src/cli/args.rs",
              '#[arg(long, global = true, default_value = "true")]',
              '#[arg(long, global = true, default_value = "false")]'

    # Redirect `jcode update` to Homebrew
    inreplace "src/cli/dispatch.rs",
              "hot_exec::run_update()?;",
              'eprintln!("Please update jcode using: brew upgrade jcode");'

    system "cargo", "install", *std_cargo_args
    rm bin/"test_api"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jcode --version")
    assert_match "Please update jcode using: brew upgrade jcode", shell_output("#{bin}/jcode update 2>&1")

    system bin/"jcode-harness", "--cwd", testpath
    assert_match "alpha2", (testpath/"sample.txt").read
  end
end
