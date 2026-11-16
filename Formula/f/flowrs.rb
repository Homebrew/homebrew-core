class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.16.5.tar.gz"
  sha256 "96547403bbce6e3713fef7dc099231b65388b01e0962807957a31d6274fe8a23"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f58af2a2f6acef6fd48e1eb4a7e9dc3edde13c441e520147ec6f3d3f362493f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29b3ae0d1d0a588b864c86e1f355e5d107462b883af508c2f6c0f9e9f6248cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e293b184285960b42a43f107581c50c4d5c019ab5ac488244df57fad658f71d6"
    sha256 cellar: :any,                 arm64_linux:       "851c7879a1c2d2db4e5ec92ee8e82f5c191d5b8dfb61ea345e1ca739f05af819"
    sha256 cellar: :any,                 x86_64_linux:      "3030256f11864a24a85801f31a2d25b1311540d4e6331d00c394a03cbc5a9bee"
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
