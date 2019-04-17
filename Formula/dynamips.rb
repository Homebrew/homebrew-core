class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "https://github.com/GNS3/dynamips"
  url "https://github.com/GNS3/dynamips/archive/v0.2.20.tar.gz"
  sha256 "c6535177c175422b741a4660697f7d9a29f19b6e42dd049e027fd7e3e152520e"

  bottle do
    cellar :any_skip_relocation
    sha256 "85e18d94efbaf681c8898e238c7716ea6f46ff417d4af91b9b2de4ada7eb1e8d" => :mojave
    sha256 "097cef7949649e074d481a3cef05cbe79e9b3c8c79d012bcb4b06bf167ac05e6" => :high_sierra
    sha256 "996275cdfb63a9edc1b0621c6bdd6c9f8b80219d0991390b1a9cc951d29e62d0" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libelf"

  def install
    ENV.append "CFLAGS", "-I#{Formula["libelf"].include}/libelf"

    ENV.deparallelize
    system "cmake", ".", "-DANY_COMPILER=1", *std_cmake_args
    system "make", "DYNAMIPS_CODE=stable",
                   "DYNAMIPS_ARCH=amd64",
                   "install"
  end

  test do
    system "#{bin}/dynamips", "-e"
  end
end
