class Fsw < Formula
  desc "File change monitor with multiple backends"
  homepage "https://emcrisostomo.github.io/fsw/"
  url "https://github.com/emcrisostomo/fsw/releases/download/1.3.9/fsw-1.3.9.tar.gz"
  sha256 "9222f76f99ef9841dc937a8f23b529f635ad70b0f004b9dd4afb35c1b0d8f0ff"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "3d02fa0e6e8a6f9518341fc3934e7b53e13ac42304b07b7088ce54384ed64371" => :el_capitan
    sha256 "2a439435d39ddd9a8c1bb978ae7ebb25415fd7a3d0c7079e6a731ecbbf035f68" => :yosemite
    sha256 "00c166987eea6babaeb7eb8005de6ae8418c18681474e534a9feeac65700d95d" => :mavericks
  end

  def install
    ENV.append "CXXFLAGS", "-stdlib=libc++"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    begin
      io = IO.popen("#{bin}/fsw test")
      (testpath/"test").write("foo")
      sleep 2
      rm testpath/"test"
      sleep 2
      (testpath/"test").write("foo")
      sleep 2
      assert_equal File.expand_path("test"), io.gets.strip
    ensure
      Process.kill "INT", io.pid
      Process.wait io.pid
    end
  end
end
