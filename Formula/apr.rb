class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-1.7.1.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-1.7.1.tar.bz2"
  sha256 "402f8fcd12fbedbf12e681900d341c1f78d71b033104b201680933dc839c8d26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2436fcb8df3235cf77a8a935c1394d56d1866c54c24c415bc8596f6a38e2e40e"
    sha256 cellar: :any,                 arm64_monterey: "6d4620fe0ebacfaacebc26778d7fbb11fbf64a5b799d062c704d71de2f8723cf"
    sha256 cellar: :any,                 arm64_big_sur:  "73d4746a4dfbdab5fb5de0c9e3f16719588e512cdb82bdb3203debc4fd5c2ad3"
    sha256 cellar: :any,                 ventura:        "c4ea18de14696d7935ea9152bcfabe3879552a9f574da1a7144e0bb3c772fe39"
    sha256 cellar: :any,                 monterey:       "573499a25e0232ba1537d857459b0aa4209daddc4a29036074d9ef39679105e0"
    sha256 cellar: :any,                 big_sur:        "b8e064bbeb1e14aa0df92917fcec6cfd00d88854199928a29f12ab4bf1ae8f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e759919ebcadd46d5801f829a970d84b52fe9cd0f76835029dd824f58ecd8b50"
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
