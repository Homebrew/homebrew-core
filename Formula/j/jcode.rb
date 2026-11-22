class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "03f078f1f97468badac9c1672df19651b6f460bc93ddd9f49579b3a83f0a1a64"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "ce07f95e9215a95f92eeef9f8d5165407fc547bcb6a1da771617cf014f336801"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60bccda2bf900c49fedeeb51c67b23dc54f826622ed7017727171a84e58f1ff1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a319eac8b501c4d989be40520b738113534ccb1ef2d70aa4b9425387edd6c90b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b41bc278c469312cec4ac6e2f5bd6d5528a7ebee2972a4dd1a9c315c71e7f450"
    sha256 cellar: :any,                 arm64_linux:       "1a95e68d6c62505b74f2599685e8b8081514005fa0812447521e9daa116c5efe"
    sha256 cellar: :any,                 x86_64_linux:      "6918ade83faa8e5ab340742846d067aae12faba9aaac83ce5a709d58ef33e22a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access! :build

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Disable background auto-update by default
    inreplace "src/cli/args.rs",
              '#[arg(long, global = true, default_value = "true")]',
              '#[arg(long, global = true, default_value = "false")]'

    # Redirect `jcode update` to Homebrew
    inreplace "src/cli/dispatch.rs",
              "hot_exec::run_update(channel.as_deref())?;",
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
