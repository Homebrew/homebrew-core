class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://static.crates.io/crates/nmstatectl/nmstatectl-2.2.62.crate"
  sha256 "3ad5a2d991e13dbdad1d0dbb6d8694cb6004712744dea38ba31d41392a0647bd"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b542a04aa7e20fb8ddb698ddd59128b0b27286000d2fa131052a8a8192dea79c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee731853637a87f368af77fcf06ecf89cbcce5ded758e4f433b2f9bab4067f24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "738cc64283b55d215a2c2886f44068fb8985f0a9819a7402164c269ade8bdc5e"
    sha256 cellar: :any,                 arm64_linux:       "591722c315774d78d1844f07c89180a109b973dddcba66ccbe83320e4074baa5"
    sha256 cellar: :any,                 x86_64_linux:      "465a203266f155cb3b38300add8b75c98aa188b618254951d83e75c49b2240d6"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    cd(build.head? ? "rust" : ".") do
      system "cargo", "generate-lockfile" if build.head?
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    cd(build.head? ? "rust" : ".") do
      if OS.mac?
        args = ["--no-default-features"]
        features = ["gen_conf"]
      end
      system "cargo", "install", *args, *std_cargo_args(path: build.head? ? "src/cli" : ".", features:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
