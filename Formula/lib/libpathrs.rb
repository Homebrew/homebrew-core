class Libpathrs < Formula
  desc "C-friendly API to make path resolution safer on Linux"
  homepage "https://github.com/cyphar/libpathrs"
  url "https://github.com/cyphar/libpathrs/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "81a251cb978665ce74bb4c391cdfe9d5dd0a40cdcf6cf276f6bec6869bde74df"
  license any_of: ["MPL-2.0", "LGPL-3.0-or-later"]
  head "https://github.com/cyphar/libpathrs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_linux:  "22a1b00617fbc3ee1b86ba5fca7482118ce965c7eda2cc4aaabaad6c464cee03"
    sha256 cellar: :any, x86_64_linux: "462db10c3a6e366f68df2a22438be28128d23453e5082d9522377071e69874ce"
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
