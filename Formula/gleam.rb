class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.9.1.tar.gz"
  sha256 "a26daec65dfca1c1b39b4d436cd0a23553e6f2ce6a0a1bd3ebfb5405e85ac715"

  bottle do
    cellar :any_skip_relocation
    sha256 "70777be1c8558f699d379114b7105b1666855ee95b3fd69b7af439a44038d0bd" => :catalina
    sha256 "2d8c0593e9f1a7435f126687b16422eb5f1e5edd7d0c4132c332fdd16a6c3108" => :mojave
    sha256 "e95b247a6e79610200134cdad6754663bedacad6a06efaac808a4d4e22f1e8c1" => :high_sierra
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
