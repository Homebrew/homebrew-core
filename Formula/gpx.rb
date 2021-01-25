class Gpx < Formula
  desc "Gcode to x3g converter for 3D printers running Sailfish"
  homepage "https://github.com/markwal/GPX/blob/HEAD/README.md"
  url "https://github.com/markwal/GPX/archive/2.6.8.tar.gz"
  sha256 "0877de07d405e7ced8428caa9dd989ebf90e7bdb7b1c34b85b2d3ee30ed28360"
  license "GPL-2.0"
  head "https://github.com/markwal/GPX.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "254414afa9fe68137739444a5c514637131eac89d208239d4de86d953bbed5cd" => :big_sur
    sha256 "60d8a577b0d45216452c475ff07e4641aec56c599a491c00409530a8fc5db856" => :arm64_big_sur
    sha256 "a982edd4fb776a077ea51294aea03533e5672dea8a7710329aadc2a3adca9ad1" => :catalina
    sha256 "f807c588535d7d941470c2d80dd58e97f4ad9e72d7da1b13cbbf87d9912a970a" => :mojave
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.gcode").write("G28 X Y Z")
    system "#{bin}/gpx", "test.gcode"
  end
end
