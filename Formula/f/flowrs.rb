class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.14.0.tar.gz"
  sha256 "dc690d7df55190b339e9ac42ff1d4d43b0f9b410088ca5a1a438eda2a1f7c7f0"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "937abe64a003e0e310ec3b8d49e2b1281591b9ec452e4d65177c7071c9ee3605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "045cb005c6eca86f6b522eb66af552ea8ee790f12e761b3d1da00b3c7ee41b2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34f965d553b15fdbbca9f9d667f1a409da4c313162caad7df2ebb383064c36f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "13969d087071323903fcfb607a67d976bbd125e0ae7c4f1949c2c53972841d00"
    sha256 cellar: :any,                 arm64_linux:   "b51a0802a824be8c53d4240dce9ee26ee87f58ef0ea636b2fb8c9cac1b6d2eeb"
    sha256 cellar: :any,                 x86_64_linux:  "8f25461052a27da65b16f78443ca207a6327c61eaf3b928a7ea1e0738eb20732"
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
