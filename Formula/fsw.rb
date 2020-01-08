class Fsw < Formula
  desc "File change monitor with multiple backends"
  homepage "https://emcrisostomo.github.io/fsw/"
  url "https://github.com/emcrisostomo/fsw/releases/download/1.3.9/fsw-1.3.9.tar.gz"
  sha256 "9222f76f99ef9841dc937a8f23b529f635ad70b0f004b9dd4afb35c1b0d8f0ff"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "749f3025e6383ae635a30302a3c61a191e57fbe88a7c74b3650749de7e9c8dad" => :catalina
    sha256 "90779855faefd63a20e1e60406430bfec63d4ce766e253dae595f01acbebbf62" => :mojave
    sha256 "d16086899f7ae88e0fd4eeaac5ede4e5749d688e9bb2385686f824f0a0e24677" => :high_sierra
    sha256 "71b5da385bf9d59d33e6c331f23cab5676284d627129ee4f0352976b8ce13fe8" => :sierra
    sha256 "3d02fa0e6e8a6f9518341fc3934e7b53e13ac42304b07b7088ce54384ed64371" => :el_capitan
    sha256 "2a439435d39ddd9a8c1bb978ae7ebb25415fd7a3d0c7079e6a731ecbbf035f68" => :yosemite
    sha256 "3d35dff82bb319e3d714fabf1638e3d9b5fa5760c04ae193ad45800507110e0d" => :mavericks
  end

  def install
    ENV.append "CXXFLAGS", "-stdlib=libc++"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
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
