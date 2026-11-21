class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https://github.com/sigoden/argc"
  url "https://github.com/sigoden/argc/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "6c2de9129c356058b46f4509596181dfcaf15a155939770d0ff553d45438ebb7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    manifest_sha256 "b781ea8a4e3363d47d8cf1b1718ccb0b864a48eade44ee5da89592460abd36fb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "612626cf19920f72261d50fa0d2ba961f905e682394fbcacb991b3ea965d8440"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "48cdfd0216a92c91c1edf9efea471293d84cc8146207fa3332c35e0adf0f1ef4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b8bb36811062e59850737fe41b07dffb2bb5619a5962b99f0310c10bfd404576"
    sha256 cellar: :any,                 arm64_linux:       "7afe7831205824bf9620b8b5054af862bf2c9cd7e5790495627e62d02d51a03c"
    sha256 cellar: :any,                 x86_64_linux:      "57b403db5ebb15b1e3bda3a1cd30b838a50e0494db9008af90d2ec6962435dad"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"argc", "--argc-completions")
  end

  test do
    system bin/"argc", "--argc-create", "-", "build"
    assert_path_exists testpath/"Argcfile.sh"
    assert_match "build", shell_output("#{bin}/argc build")
  end
end
