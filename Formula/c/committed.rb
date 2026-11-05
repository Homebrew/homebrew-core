class Committed < Formula
  desc "Nitpicking commit history since beabf39"
  homepage "https://github.com/crate-ci/committed"
  url "https://github.com/crate-ci/committed/archive/refs/tags/v1.1.12.tar.gz"
  sha256 "790c3d3a4cd65c0587e0aa5cfeebf3ad648bc5476f7d8ba2960dee114a30c3a5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/committed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91ed5927b949d7b8e4322f68601a5db2350e8b331e3239fd1d9f99d7f3f8906d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd2122a39de5b2bb0aba7fe997c11f2e6f75e6073d460a0eef4b5edccf43637d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "91a0a892be8fd45dab0b3fe0d9b3436595d9fd740f20cb8cf4bcbd8ddc705ee2"
    sha256                               arm64_linux:       "f4464a69c1bcd9803aab21866c862379eadd33492d6a3c5ae6f6f51b8ef1c507"
    sha256                               x86_64_linux:      "2c2662a3036cba8bfc52511a840358cae2104547608d6140bcd0b27867866a9a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/committed")
  end

  test do
    system "git", "init"
    system "git", "-c", "user.email=a@b.c", "-c", "user.name=t",
                  "commit", "--allow-empty", "-m", "bad message"
    output = shell_output("#{bin}/committed HEAD 2>&1", 1)
    assert_match "Subject", output
  end
end
