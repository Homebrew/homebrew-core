class Funzzy < Formula
  desc "Lightweight file watcher"
  homepage "https://github.com/cristianoliveira/funzzy"
  url "https://github.com/cristianoliveira/funzzy/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "ebec4e15771fedf8c9bb0c32c0ec4b90b2d24887bc3b8fa054efe7b197f4a4e6"
  license "MIT"
  head "https://github.com/cristianoliveira/funzzy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad1b3ea1b3c8bfc22526c6d298940269735bb36acbf1614e2c6f5943b01feae4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e938955195d1c31fc67858f12e7d9a06049145822138d370fef340772ad44cbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6086d1456b343981a0c95c93400956776754ac251ac2a32bee3b93dd7de4063"
    sha256 cellar: :any,                 arm64_linux:       "4e153109de65977d5530ff52a705c919831f2eb8736f18a453ba7eb72924da68"
    sha256 cellar: :any,                 x86_64_linux:      "279f2001b326cb2e0161793a7e1f7a6f3eb7e806cf089fffa7e9140bc4c3202d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"funzzy", "init"
    assert_match "## Funzzy events file", File.read(testpath/".watch.yaml")

    assert_match version.to_s, shell_output("#{bin}/funzzy --version")
  end
end
