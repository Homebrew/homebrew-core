class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.10.1.tar.gz"
  sha256 "9627e232024e6e53bf3ce5529d2f82085fa387752515cc22973036429ee73d6f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d5332beca9248b573913469bd8a70c74f25d6623c2d79bef29833d391395070" => :catalina
    sha256 "8b1cfc2270dc2aea368d347cc83dbea5d3ad268bc8c975b399ca3afb3ee9ef67" => :mojave
    sha256 "ac970d9ee863d7be6b180824555a112fb8c110a60a3765b64645c85d086d465b" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
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
