class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.12.4.tar.gz"
  sha256 "5377c874309fa6e024ea8a8563dbf7cec8dd9c7165f5e28d63272e6430d62055"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "370e3c8ab71f10f881731da7eef338b477e53379c47d5684af5a5fa568fd7b82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8462be9168732c4c8efd54cc1888c91a51d455a2fb1c6623f56575f206663f87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db1b49d5edac20ad1b5ee7f6da0081b5c3af15702ff655456c3210e3eca1f598"
    sha256 cellar: :any_skip_relocation, sonoma:        "a949291c3f379a4f2b2969a2603442b95e8ae08565fa0f2d4e71a076f0928e26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "438afd8d7ca297d24f1a868bfc5cb7dacb4dd56332a81f8ad569919b3ee3242b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67b773e5e15789dbb92a4068a4e075871133c023dd9e5323136acb763a04509c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
