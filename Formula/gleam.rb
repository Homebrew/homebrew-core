class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.5.1.tar.gz"
  sha256 "3eaf724ba3e558dc14d5ae076f138f02fbe80d15b4487bb32f8834f4f6d81f91"

  bottle do
    cellar :any_skip_relocation
    sha256 "24c80811158e22e2ef1d9d4d5e7d3669b6e79733a0390bd919e35fbb323bb19b" => :catalina
    sha256 "e6992a3016f71029e490c2f1469b74b4397ef3095e2cfcee3ae41d3bf98e3713" => :mojave
    sha256 "57a840fb371cfb73856afce4dd3ce162b371da0b4879b6c9efe085029df1b40f" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
