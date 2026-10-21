class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.16.1.tar.gz"
  sha256 "b88e2b5fbcc42182c9b38f5572d5f9222ce73f3fd421eb40da4bd30cc6583aa2"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "50c1d6cb1dddca69c233d8f700b3108f5755a9d316fc9d76d67ddd8a636e6331"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fde68e0f01e791500e268e8373b068d7634fbd24aca9c0a99b32531dd9f3a68b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6142f95e60793f80415c7b97c6faaa6846b184a8c07639d23835659d1cc9e1ee"
    sha256 cellar: :any,                 arm64_linux:       "f29b94646b670ac7814ab85862f46411d0062174b6a5edd65cf97d034d0318c8"
    sha256 cellar: :any,                 x86_64_linux:      "453959e5578b638f07410b7e3884d7d2a8d723916b09a415bc3aa53294463453"
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
