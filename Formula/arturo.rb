class Arturo < Formula
  desc "Simple, modern and powerful interpreted programming language"
  homepage "https://arturo-lang.io"
  url "https://github.com/arturo-lang/arturo/archive/v0.3.6.tar.gz"
  sha256 "c6c584f9e0fed0d82ecb81f2bf7481fe1b6b2918fe6bc588f8c9f851c68ea18c"

  depends_on "dmd" => :build
  depends_on "bison" => :build
  depends_on "dub" => :build
  depends_on "cairo" => :build
  depends_on "atk" => :build
  depends_on "gtk+3" => :build
  depends_on "jpeg" => :build
  
  depends_on macos: [:high_sierra, :mojave]

  def install
    system "dub", "build", "--build=release", "--compiler=dmd"
    bin.install "arturo"
  end

  test do
    system bin/"arturo", "--version"
  end
end
