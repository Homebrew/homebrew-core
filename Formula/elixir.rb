class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.13.3.tar.gz"
  sha256 "652779f7199f5524e2df1747de0e373d8b9f1d1206df25b2e551cd0ad33f8440"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3357acc49bbaeda3956829aabb43b4fae8bd2b618785f8e7345da47878833bcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f750f422dcadbb6da09c8b3ed0df918baa6bde8fd8b92426d53c9e058c4eb6b"
    sha256 cellar: :any_skip_relocation, monterey:       "6d046e013bb667a11a74ec3e1bfbc8decd77f3002df9843af35b7a6ff5d05d3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d3bcdccd61188a17bc9e01e711454304d9807ae1e9fa860966bc1c6eb7e49fa"
    sha256 cellar: :any_skip_relocation, catalina:       "201a6ef46b36f3e8fbcd0b54af24dbb8a5279ea8c5c52996c6efe2c250bfa443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7c5b0bc2a814fdebbe46c3b1ca6358a4f3b40d4972e7e6e54600035710a2668"
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
