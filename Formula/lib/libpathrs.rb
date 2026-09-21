class Libpathrs < Formula
  desc "C-friendly API to make path resolution safer on Linux"
  homepage "https://github.com/cyphar/libpathrs"
  url "https://github.com/cyphar/libpathrs/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "ae274cd296b863d538e28ee42e612f40723f9f0b2601a41c5b796ac074e5eb9c"
  license any_of: ["MPL-2.0", "LGPL-3.0-or-later"]
  head "https://github.com/cyphar/libpathrs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_linux:  "7c76680f600201bc7e6ce67d6c9f4986276d9202c202838e06119f2be1db3208"
    sha256 cellar: :any, x86_64_linux: "3f164db4ca74c4b95a6fcc699e831d43f3946abc21eff1d959846c62c9e9fbb6"
  end

  depends_on "lld" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux

  def install
    # Not parallelizable because hack/with-crate-type.sh modifies Cargo.toml in-place
    ENV.deparallelize
    system "make", "release"
    # install.sh is the recommended installation method
    # https://github.com/cyphar/libpathrs/blob/main/INSTALL.md#installing
    system "./install.sh", "--prefix=#{prefix}", "--libdir=#{lib}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <pathrs.h>
      #include <stdio.h>
      #include <unistd.h>

      int main(void) {
        int fd = pathrs_open_root("/tmp");
        if (fd < 0) return 1;
        int resolved = pathrs_inroot_resolve(fd, ".");
        close(fd);
        if (resolved < 0) return 1;
        close(resolved);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpathrs", "-o", "test"
    system "./test"
  end
end
