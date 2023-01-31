class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-1.7.1.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-1.7.1.tar.bz2"
  sha256 "402f8fcd12fbedbf12e681900d341c1f78d71b033104b201680933dc839c8d26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e0a879c211c9c211262e55211187abb8c8c87f2ca14d6f41e144039312058e54"
    sha256 cellar: :any,                 arm64_monterey: "02e6b44b3284fa471cce15592a8666356f8d43b256bb08b391efbd521eddedd0"
    sha256 cellar: :any,                 arm64_big_sur:  "26736a76f4ad71f17a1a5068bbe0a1bfa2c48e26622d3ed959f3ce42165ddd0c"
    sha256 cellar: :any,                 ventura:        "3e01846ed6a8996e8bddb4c65fb352d185ead8ca56e42bb75b9be7640937c9e4"
    sha256 cellar: :any,                 monterey:       "365d71d8598761991d7c37831d11a4d355a5dc007863e5a677afd39d664d8351"
    sha256 cellar: :any,                 big_sur:        "e397174ca8509867732b3b39bd3620288d84504584320355c9b1d85df0350e9a"
    sha256 cellar: :any,                 catalina:       "ee9d9b6e5bb722c31ffac5ea0d2497f65feae2e69d73cafa44d63c99312d373d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9166ca46f30bc3f48b1087f107370800bb97ed74493cca5fc887b66ebc4c481b"
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
    # Remove at version/revision bump from version 1.7.0 revision 2.
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
