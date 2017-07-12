class Precomp < Formula
  desc "Command-line precompressor to achieve better compression"
  homepage "http://schnaader.info/precomp.php"
  url "https://github.com/schnaader/precomp-cpp/archive/v0.4.5.tar.gz"
  sha256 "39add141554f0186200911ab61838b69f5777956b3dfd37d82bb6923607258dc"
  head "https://github.com/schnaader/precomp-cpp.git"

  def install
    # HEAD already has that, but current stable version does not compile with clang without that patch
    inreplace "contrib/packmp3/Makefile", "-fsched-spec-load ", ""

    # Seems like Yosemite does not like the -s flag
    inreplace "Makefile", " -s ", " "

    system "make"
    bin.install "precomp"
  end

  test do
    cp "#{bin}/precomp", testpath/"precomp"
    system "gzip", "-1", testpath/"precomp"

    system "#{bin}/precomp", testpath/"precomp.gz"
    rm testpath/"precomp.gz", :force => true
    system "#{bin}/precomp", "-r", testpath/"precomp.pcf"
    system "gzip", "-d", testpath/"precomp.gz"
  end
end
