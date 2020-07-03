class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.10.0.tar.gz"
  sha256 "f909fc7c89c950f7a8fffc943733dc4bac3b0b88eb7d7760eb04732347459ba1"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6cc30c84004f50f76c4d7501814e5311482619c96b56e7e51f9b706e3490c25" => :catalina
    sha256 "724d94e8bf2556d9485423de6ed21efbc53326114f245d9ac24d96e20f57a96d" => :mojave
    sha256 "4735f65ab3a0ae5614feaf1433cd103edc1ea6ee2de59c2383e051047834ff55" => :high_sierra
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
