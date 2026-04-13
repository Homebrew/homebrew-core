class Libpathrs < Formula
  desc "C-friendly API to make path resolution safer on Linux"
  homepage "https://github.com/cyphar/libpathrs"
  url "https://github.com/cyphar/libpathrs/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "2bd56d6cfdc6b2394740a329efdaf9eeda315ae947c68adb1f673a3cb76f65a7"
  license any_of: ["MPL-2.0", "LGPL-3.0-or-later"]
  head "https://github.com/cyphar/libpathrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "54e2fb4e4f26b0e376cf5435f6b76c391e001fc3dcd4661614952e193d2600c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "19d30702ac6daba0bd789f87a94d19ebc66152f1f8a8d7b550f9f5e3159a8935"
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
