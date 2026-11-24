class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.16.7.tar.gz"
  sha256 "51cd456626515fd5a13ac1a363c2f9e59b61288866ae3c22c82b842bf0c77cae"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "5abd9eb81bff9be206aed38f3ec4d8b77280fc214c2126976227c8a673f91b10"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "314b9e0f8fa55bfb339166f8798b8cc96417daefa507280a091bc300d3f2b08f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bab86f5791a0ce858a0fb6530a579d703b9c42fc7a772565a844ca82c50961b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a58b8508338e17e54fc60705e2c91c88c5953a2d61b1425201c2e470091b9a1"
    sha256 cellar: :any,                 arm64_linux:       "087bd9cc9687f725dc0a493824f04074dbbc9eec17a7d5a3eb876a90435c0c8b"
    sha256 cellar: :any,                 x86_64_linux:      "0977be8ea28a874ebbfeab7423c5795ea26420bd652be5ff1125597f658b0da1"
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
