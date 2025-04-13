class OclIcd < Formula
  desc "OpenCL ICD loader"
  homepage "https://github.com/OCL-dev/ocl-icd/"
  url "https://github.com/OCL-dev/ocl-icd/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "8cd8e8e129db3081a64090fc1252bec39dc88cdb7b3f929315e014b75069bd9d"
  license "BSD-2-Clause"
  head "https://github.com/OCL-dev/ocl-icd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d7c8afe9e6b8ffe2a22f19d6e5c83308d667b9900ecbbeea099877edd9158eb6"
    sha256 cellar: :any,                 arm64_sonoma:  "8a01c3947a0c26d9838becad8e921973b537e082a3eeaeaec6fd096451f63aa5"
    sha256 cellar: :any,                 arm64_ventura: "a1a5c38cc3f5225611ae2bb8d374150bbcb6477df308cda5f2794578f1fa2741"
    sha256 cellar: :any,                 sonoma:        "ca8f8666d60286deb53df27393f6bd8aaf992189205cc11906252a119d6e2e2d"
    sha256 cellar: :any,                 ventura:       "fc457f354e908f301613f53f00724dfd2004703095db6cd07e24eb4836e7fb38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3544838851909491b806b9c6123ec2b86521f98f09100a6613fe6f56d47fcda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cecdc2cd21d76f3037b0357fbbe8bfbbd5eba87007131cfc71b5cb47177302dc"
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
