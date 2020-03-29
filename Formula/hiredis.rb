class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v0.14.1.tar.gz"
  sha256 "2663b2aed9fd430507e30fc5e63274ee40cdd1a296026e22eafd7d99b01c8913"
  head "https://github.com/redis/hiredis.git"

  bottle do
    cellar :any
    sha256 "c177c929273ea8417f27986345191201ce81b3799fbdc186e5cb3da4b8932f31" => :catalina
    sha256 "3730e073d04b6256125b11b0960664aa2910f49f6e0430985d4c15c8ac7a18c9" => :mojave
    sha256 "d7f4ba1ad751186e5552923717f5aae58d0fbd040f5360cda77ae16e777784c2" => :high_sierra
  end

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = "-arch #{MacOS.preferred_arch}"

    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, "-I#{include}/hiredis", "-L#{lib}", "-lhiredis",
           pkgshare/"examples/example.c", "-o", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
