class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.17.0.tar.gz"
  sha256 "4cbe6353e0e6b4a90e1d2b30182b6bc585673fa7f9590b17e7171180ac202ada"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "e2c8fef0c5b9c82c3837324b101fb1a2ac9c40700f2c1308befa259dde165650"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82634273c8ff5e0c6eb6d8c5702a63f940959fd6d1967ebf7e497e3f5a3f3a4a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b95e9fce75c44c7f3ed049e2b2541813053796c76c6e93b1392e1218cae10f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7454810fa7f992a49c9cbfd39ebd5357e71923509f3e7dfaa1365f88fb285c30"
    sha256 cellar: :any,                 arm64_linux:       "d2c381c76ccdc5b520d17ba4e425894a7cf6a82b2afa57a26d228bfcc34cd0eb"
    sha256 cellar: :any,                 x86_64_linux:      "b7bf1e40ca16ea4f03d883579634b2a1324157bf9236c77d60284987bc784dac"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
