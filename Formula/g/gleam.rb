class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "d965a02c1c3b35c70fda49d483eb1fe3fb02045b6126453a1e8e9d91ed029cb4"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a93d1f6ff59aeb4e1704215548f99fa634b61c356a9d27b69eacd577c24d12d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b055e3ad3b4465ee3088ee198a65fc9f6b2917455229f385d431290767956c99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "822a99e6ea588a5aebe3141bea813a7326df9fe1a66407f4dbe720905911d5f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "70300f75247ad4515a4bf5cf789970c5b016a1e9dc32947ff919051dce4cbe1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dc840414c3daa6432cc4c19e4adf8a0c3227c2a3a40b9e304e474cf5bad4c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fe9d2026cc9cf15e10685fd36d78f91a4b85960c0ecdfa217e1bddc4a77bd44"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "gleam-bin")
  end

  test do
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
