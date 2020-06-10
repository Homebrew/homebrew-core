class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.9.0.tar.gz"
  sha256 "085ad8c055315bff592fedca3ce75635d25bf9298444fae75b0aea859ec2ad97"

  bottle do
    cellar :any_skip_relocation
    sha256 "172c8ce61f531c1aae4ede10bfbeeb46dbbe52121a100bc0c41bc7ad300419e5" => :catalina
    sha256 "f9565b0921dc640fc3f2e1d57e9b9c9a55856b9ebec4d1a052221d899952ac20" => :mojave
    sha256 "4224fee5d849fc590d11f43b61810c5cd7970a1f1ae48a45c3c5e4a625eb09f2" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

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
