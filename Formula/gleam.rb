class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.7.1.tar.gz"
  sha256 "cab8daf5f7f6ffbf1d43b3d188690f9b01bf8faf7ad4fee4811648502a1a1301"

  bottle do
    cellar :any_skip_relocation
    sha256 "13b302bb841848da6d01318965e300ff2a36d6cf5e7ed18c7aac5f1a205089ed" => :catalina
    sha256 "e72c728f7a8220f4ac906c7873739e63eb49ec99e427509c52666dc7c0e02bed" => :mojave
    sha256 "bae9b42449c6e75a13d7af3c29851580f36626ed1e8cf99b925ba266bfaa9e6c" => :high_sierra
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
