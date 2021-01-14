class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.13.0.tar.gz"
  sha256 "aca2a0ec1a9f9e492ef73b64ac4a5d0bd6f37eaf3eb74e8a35dff6469111652c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a197a01d2a4ccc244b3042a46dd1c498ee02480162fc9deba37bf74ac533192d" => :big_sur
    sha256 "a7f9676fbd4db882933f8f55bf649808b820057b9fb7eca2017c28389cee1c30" => :catalina
    sha256 "6e99065ad1c05a84707f42871a2852ec5b0d94cf8b98fb6165baa461d19f0682" => :mojave
    sha256 "602eea271860c2baefc912d19985395ec70484ea9239304e9c76d7f394d99eb5" => :high_sierra
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
