class Arturo < Formula
  desc "Simple, modern and powerful interpreted programming language for super-fast scripting."
  homepage "http://arturo-lang.io"
  url "https://github.com/arturo-lang/arturo/tarball/master"
  version "0.3.6"
  sha256 ""

  depends_on "bison" => :build
  depends_on "curl" => :build
  depends_on "dmd" => :build
  depends_on "dub" => :build
  depends_on "flex" => :build
  depends_on "gtk+" => :build

  def install
    system "dub build --build=release --compiler=dmd"
    bin.install "arturo"
  end

  test do
    system "false"
  end
end
