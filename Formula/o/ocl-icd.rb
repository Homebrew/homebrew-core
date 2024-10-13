class OclIcd < Formula
  desc "OpenCL ICD loader"
  homepage "https://github.com/OCL-dev/ocl-icd/"
  url "https://github.com/OCL-dev/ocl-icd/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "ec47d7dcd961ea06695b067e8b7edb82e420ddce03e0081a908c62fd0b8535c5"
  license "BSD-2-Clause"
  head "https://github.com/OCL-dev/ocl-icd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9ff3e5d0477e86547da714292eb3f7301027038539b299d5b90381a84da824c7"
    sha256 cellar: :any,                 arm64_sonoma:   "df3cb16228261aa527b898620e55f267201a7a46a0841f36e573136810531a07"
    sha256 cellar: :any,                 arm64_ventura:  "8fc901e1e752f1902b2121429848130015c185950ba6d95493799e16f4682657"
    sha256 cellar: :any,                 arm64_monterey: "02b44e5ee419f3b8b41a022cb18686b8228e9d7f25dc2e577ecbc0416dad3826"
    sha256 cellar: :any,                 arm64_big_sur:  "9c235f1e589eb8bf190044f779cd4dfea39933ad6204d04425e169decacda436"
    sha256 cellar: :any,                 sonoma:         "d81c26148b1fd2d1af2eb1e194db88a9d8d11c7979fb5e80e0e1b32772e3700a"
    sha256 cellar: :any,                 ventura:        "a94ce49fa8125e0280560433f7e6dd73fbed00275f63d7ee1128de8c90b02397"
    sha256 cellar: :any,                 monterey:       "d7f1221c1e6e98a8f83f6e9a73a52156a10d41335ed4cfab2452c4af9fb8442b"
    sha256 cellar: :any,                 big_sur:        "c2bcc480d4d10eb4b38ebec517ae32b936e272f9c559e6f8e17a2c7efc916dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75434ef5697505daea48897d562dc77f1daf9c6d2ff938684d75bf3c5f2fbcc9"
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
