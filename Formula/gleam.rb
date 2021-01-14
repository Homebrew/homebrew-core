class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.13.1.tar.gz"
  sha256 "effa8d8e676863f9ae0ddee0c02a47108d4188fffb7cd17b672afcf26867dfe1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "216a1d09710c5878220146453ae52ee6e5011c5a96de4f70fa7c86938d929ea0" => :big_sur
    sha256 "52530d8d876d7558a890bf6ee3b19ebab23f23b0cdd56f623474904fc11b639b" => :arm64_big_sur
    sha256 "131b2d2529b51116ac5e08c7d31ce20b8a95b7847e4366c56765fbbd0c45bebb" => :catalina
    sha256 "08ac36013211ecc063be3f648edfad5d193ef76a8900642f273761b7e7b3e1b9" => :mojave
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Update stale Cargo.lock file. Remove at version bump.
  # https://github.com/gleam-lang/gleam/pull/921
  # https://github.com/gleam-lang/gleam/issues/920
  patch do
    url "https://github.com/gleam-lang/gleam/commit/de5558211bddcf95650b8134abb8c9d5a1cca5f8.patch?full_index=1"
    sha256 "7ab714dec653994f67f38431e7f06eb9131f5a109926f814a92a66f1a183c2e4"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
