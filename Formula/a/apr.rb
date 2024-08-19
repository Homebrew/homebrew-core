class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  # TODO: Remove `libexec` symlinks in `install` when we no longer have a Big Sur bottle.
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-1.7.4.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-1.7.4.tar.bz2"
  sha256 "fc648de983f3a2a6c9e78dea1f180639bd2fad6c06d556d4367a701fe5c35577"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e227070223b674f0a34de0a7415809c2658c4a141c72bd5d89eb7a48e38ef651"
    sha256 cellar: :any,                 arm64_ventura:  "55701a760762df4b13e8ea020e3b9f3cbab2bc98c4e454ebc8da6e1e732c6019"
    sha256 cellar: :any,                 arm64_monterey: "cdf180eedc873e0be54f957c15db9f9e3f9fa31bae241177a5fea10712cec4e7"
    sha256 cellar: :any,                 arm64_big_sur:  "68c28d40b2d94452663cc4f73a5f63ec4b4e3fa41df52e427808a7b560108ae7"
    sha256 cellar: :any,                 sonoma:         "81be61aa626fc6b6ec2b4448e6252da33997176a922cd4cdd0086ddd11aa3703"
    sha256 cellar: :any,                 ventura:        "f12547e5dda5a279d9e179b177ba268a8f9d8bde75fd27e239d6a6c0b2badeba"
    sha256 cellar: :any,                 monterey:       "f8167e19ca4a4d6e60f134800aef9db00386049600ef1ddb5a1d57666fd15cba"
    sha256 cellar: :any,                 big_sur:        "5364e94a85ef867608891ff3de3a616ce285c67bb4bb9dd24c15b6726c28c528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46ee2796d8449bb3af0ddddceef945f64e25a28fead1e5b7661e430e8e81275a"
  end

  keg_only :provided_by_macos, "Apple's CLT provides apr"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "util-linux"
  end

  def install
    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    system "./configure", *std_configure_args
    system "make", "install"

    # Install symlinks so that linkage doesn't break for reverse dependencies.
    # Remove when we no longer have a Big Sur bottle.
    (libexec/"lib").install_symlink lib.glob(shared_library("*"))

    rm lib.glob("*.{la,exp}")

    # No need for this to point to the versioned path.
    inreplace bin/"apr-#{version.major}-config", prefix, opt_prefix

    # Avoid references to the Homebrew shims directory
    inreplace prefix/"build-#{version.major}/libtool", Superenv.shims_path, "/usr/bin" if OS.linux?
  end

  test do
    assert_match opt_prefix.to_s, shell_output("#{bin}/apr-#{version.major}-config --prefix")
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <apr-#{version.major}/apr_version.h>
      int main() {
        printf("%s", apr_version_string());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lapr-#{version.major}", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
