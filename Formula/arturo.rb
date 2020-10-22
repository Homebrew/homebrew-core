class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "http://arturo-lang.io"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.4.6.tar.gz"
  sha256 "90dfd8870ab0bfadd14cd611a33353a1d4b66b25e0c56d75cab895989be25c98"
  license "MIT"

  depends_on "nim" => :build

  def install
    system "/bin/sh", "build.sh"
    bin.install "bin/arturo"
  end

  test do
    system "#{bin}/arturo", "-v"
  end
end
