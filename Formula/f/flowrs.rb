class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.12.6.tar.gz"
  sha256 "bdb6043e71ea18cd234658cac72a8ef102843b7ac93a547a637a6488a74864ce"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e70992d01aa3ebebfd31d4f16b32b065d918127093a8e764bd0e89d0a958af02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "977f4645b41c62105545c1327bd033459e9bdbddb089fafbcb095a199debe9cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cff762cc7046c39050192114dbb72b20c4dca5b4b38bce160b371b8ccad9136"
    sha256 cellar: :any_skip_relocation, sonoma:        "f67761364e2d711c87c331e39f6cdb6ee6180fde27b14ab4599de77763048959"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41b0f1447241a69110953667f0197c34818b34dc177c35eaed3e6a92aab158a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36d51586b1fe007cb170ac45b20326e61b504e0182d7fe2436fa805f50ddcbd6"
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
