class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.4.0.tar.gz"
  sha256 "00af1865422ef8c57bab7b7f234b03b27cacd69f6eb23375615c60cb089458e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b7d2b2d9c2243737031bb43cbc02a0e82e87057aa7fd7eeeeb702f7b0f6f60a" => :mojave
    sha256 "896ed7d9f5146c1ed18df18f88271194ba7d2d927bb07625186ee665e3750e59" => :high_sierra
    sha256 "90e947bd357a947529cdf47f56e8a73ac318d672fefdc88966ff1242ad88005e" => :sierra
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", "--root", prefix, "--path", "gleam"
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
