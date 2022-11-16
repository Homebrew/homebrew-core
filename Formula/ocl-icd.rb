class OclIcd < Formula
  desc "OpenCL ICD loader"
  homepage "https://github.com/OCL-dev/ocl-icd/"
  url "https://github.com/OCL-dev/ocl-icd/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "a32b67c2d52ffbaf490be9fc18b46428ab807ab11eff7664d7ff75e06cfafd6d"
  license "BSD-2-Clause"
  head "https://github.com/OCL-dev/ocl-icd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "646b216df67d7b7e735b31b4a1d24e034ea35d7815bc4cef00dcaf863b8f2234"
    sha256 cellar: :any,                 arm64_monterey: "7fb55097c6ef597b45a65e372b897f1ced819174b5d2be6998c08f83ec63f7e6"
    sha256 cellar: :any,                 arm64_big_sur:  "47b40dd06f5bd6a11d7e2ed89e8d257e17f35625b61326114439181d2d53d488"
    sha256 cellar: :any,                 ventura:        "251788ad1ce52b3d42bb6724df586a3fe8ad5e72a7365a75f058fe96bde1189f"
    sha256 cellar: :any,                 monterey:       "f40f52fd6d1f469581f51ce37d17ddb865cfa9483b4ff393a19512428828c1f9"
    sha256 cellar: :any,                 big_sur:        "d943f89dc5553e17dd5135392360658164936a21602213588a879ae6da43a6a7"
    sha256 cellar: :any,                 catalina:       "669aa5385b9467f450bdbb51bb0a6928d4bd6740589f634e9886bfa2929c065c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8725f2b095bda280dbc3225f40490fc2a1d47c37b0dc50a619e2a2e5e9da3e1e"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "opencl-headers" => [:build, :test]
  depends_on "xmlto" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build
  uses_from_macos "ruby" => :build

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "./bootstrap"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-custom-vendordir=#{etc}/OpenCL/vendors"
    system "make", "install"
    pkgshare.install "ocl_test.c"
  end

  def caveats
    s = "The default vendors directory is #{etc}/OpenCL/vendors\n"
    on_linux do
      s += <<~EOS
        No OpenCL implementation is pre-installed, so all dependents will require either
        installing a compatible formula or creating an ".icd" file mapping to an externally
        installed implementation. Any ".icd" files copied or symlinked into
        `#{etc}/OpenCL/vendors` will automatically be detected by `ocl-icd`.
        A portable OpenCL implementation is available via the `pocl` formula.
      EOS
    end
    s
  end

  test do
    cp pkgshare/"ocl_test.c", testpath
    system ENV.cc, "ocl_test.c", "-o", "test", "-I#{Formula["opencl-headers"].opt_include}", "-L#{lib}", "-lOpenCL"
    ENV["OCL_ICD_VENDORS"] = testpath/"vendors"
    assert_equal "No platforms found!", shell_output("./test").chomp
  end
end
