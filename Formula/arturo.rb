class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://arturo-lang.io"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.6.tar.gz"
  sha256 "b9028b97537a81f4bb7dff6c036ed84d951292e858653dbb2012b0ae069cd509"
  license "MIT"

  bottle do
    cellar :any
    sha256 "cd975a138c834193d32c9f76514153f38841ed3c9e8c37000dd045017124d2fe" => :big_sur
    sha256 "65a4a6052d7e932286165074d4faf3b4a81993c11ed769e0587d5854028babaa" => :catalina
    sha256 "2b6040141a9b688b998b64e099f85f99ad2002972541df8384c204eb444f7da5" => :mojave
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mysql"

  def install
    system "./build.sh"
    bin.install "bin/arturo"
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end
