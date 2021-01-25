class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.9.tar.bz2"
  sha256 "d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da"
  revision 2

  livecheck do
    url "https://aubio.org/pub/"
    regex(/href=.*?aubio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "53bc8066ab50f4e4c24aad5f31e96f1ce0abac84930e5fcce43fa8f6083a878e" => :big_sur
    sha256 "f6db53233e1b2855491b4b9310a579e4ac51c3dab7ac426f5c1c64b2fc0820f0" => :arm64_big_sur
    sha256 "9b24159cf4c8adbb1a78c5cab192453ebebd47260612d38005683ff093250b45" => :catalina
    sha256 "653f41a951b87cf01049ed6a7019a3d2c96e635fc16d3be4d5edf3225b0a5f52" => :mojave
    sha256 "d6cc3ba3c3a257f4d5b4c1c3a9c0c8cca4fccf09ffc682901888d26c039886a8" => :high_sierra
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "numpy"
  depends_on "python@3.9"

  def install
    # Needed due to issue with recent clang (-fno-fused-madd))
    ENV.refurbish_args

    system Formula["python@3.9"].opt_bin/"python3", "./waf", "configure", "--prefix=#{prefix}"
    system Formula["python@3.9"].opt_bin/"python3", "./waf", "build"
    system Formula["python@3.9"].opt_bin/"python3", "./waf", "install"

    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
  end
end
