class OclIcd < Formula
  desc "OpenCL ICD loader"
  homepage "https://github.com/OCL-dev/ocl-icd/"
  url "https://github.com/OCL-dev/ocl-icd/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "1a302b71b7304cca5a36f69d017b1af2b762cc4c2dd1c0c0e2fc1933db25c9cc"
  license "BSD-2-Clause"
  head "https://github.com/OCL-dev/ocl-icd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d9be02fbfaf871daf5cb668b8b4ea97d663f80417b91f472170505b9ef9789b"
    sha256 cellar: :any,                 arm64_sequoia: "08c6eb98086b19296a76f35e4e7f4d7449e4f80901d2640d201ef04db9b0e0d7"
    sha256 cellar: :any,                 arm64_sonoma:  "88c084b65ff3a60594b313196d284d80f6abd7eacfd03a991216a29a3672e2a0"
    sha256 cellar: :any,                 sonoma:        "77ce6f71726a4c043d727ff7826b590fe3245ac7c59ae433a746494b8d4ae89d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "913ab871ddcffee2b49fd8ccc776758b5c918f7ab7141b72286aac0005469bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cd60c1551f2f69e72c1be4b68440afd95960ac2e272e5ff34e12ea84c00a3ae"
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

  conflicts_with "opencl-icd-loader", because: "both install `lib/libOpenCL.so` library"

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
