class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "0c85e1f3d7edb600fff80778813f9c507db4c663f61b2fc017c1ba1ad3d2caf8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "03ab59ae7a8993deb7dfd201b76e676a5efad13316cb9853fef54cfd9fc4b5dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f90e48840428fb599393ac21ba7b2c14bbdb858190df8c92738b3b7e15591080"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "569233e9d1d3bdb79b8665ae587e5bfa6b4e5ac88cb6a6059e54d2ee638adcc7"
    sha256 cellar: :any,                 arm64_linux:       "d5ed89e8377d7c9b0d078197b9db1f22d4f9d7bdba8bc0bc1e823d6bb434e612"
    sha256 cellar: :any,                 x86_64_linux:      "8f4e4c8489d4856340be64304568668b6de1b66b25b92cdc60e4cb2e2c335ff6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end
