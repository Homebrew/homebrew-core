class OclIcd < Formula
  desc "OpenCL ICD loader"
  homepage "https://github.com/OCL-dev/ocl-icd/"
  url "https://github.com/OCL-dev/ocl-icd/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "cdd7984425fa92d37273eee4180b5f57b047eda6dd8fd623e58498f844b09b75"
  license "BSD-2-Clause"
  head "https://github.com/OCL-dev/ocl-icd.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a7516791a7b101b8b28008e91152a41d4bccef8e432ec57f5176d058ce316425"
    sha256 cellar: :any, arm64_sequoia: "850088b50e703f2ac49f1aba5174e9b2d02120407c3091c5bd0098e172cfdc50"
    sha256 cellar: :any, arm64_sonoma:  "78f5a4c7128cf8823f22c211de7496af79a8b07c141ffd082aa3c175b314e53d"
    sha256 cellar: :any, sonoma:        "13f114294b4cb291958abecbc83cc3b44661dd24e8392944ae90c732c06204d1"
    sha256 cellar: :any, arm64_linux:   "b17b8aab84f730877784d6defa8bc9086457d0bde5bc635feafdca61d2ee02b8"
    sha256 cellar: :any, x86_64_linux:  "86b5bd9b0f6d3d7bca91b916bda8ade6349c47a227392f559d93177cc41b39e2"
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
