class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-it-sdc-id/davix.git",
    :revision => "fdfb0def157e19d674d3b7018c3c41fcc38106d7",
    :tag => "R_0_6_4"
  version "0.6.4"

  head "https://github.com/cern-it-sdc-id/davix.git"

  bottle do
    cellar :any
    sha256 "d3a395830226bef00670203b6d14b9f23a86bb63f42e3fed935b7a5e7aea329d" => :el_capitan
    sha256 "c4acf2c4d20d1691ea9d90d147510a4b10223974348cb30db8000c344caffb13" => :yosemite
    sha256 "9be1c102bb422ad53d9f616ab53ba1a881bffed0cf59a85e89d6a8807c41c8fe" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl"

  def install
    ENV.libcxx

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "https://www.google.com"
  end
end
