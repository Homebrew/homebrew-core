class Libpathrs < Formula
  desc "C-friendly API to make path resolution safer on Linux"
  homepage "https://github.com/cyphar/libpathrs"
  url "https://github.com/cyphar/libpathrs/releases/download/v0.2.6/libpathrs-0.2.6.tar.xz"
  sha256 "7b1e3a2c3cc0bd9f94187edbb6d1ba9737deb2bf7f724df1ee37653ea405b2b0"
  license any_of: ["MPL-2.0", "LGPL-3.0-or-later"]
  compatibility_version 1
  head "https://github.com/cyphar/libpathrs.git", branch: "main"

  bottle do
    rebuild 1
    manifest_sha256 "5be177dcf60635f53c5421cdc69fda26c4fd1a9c29d942f1176ba2cf93cbc4ad"
    sha256 cellar: :any, arm64_linux:  "8b32c69a959a1e3508b4d81285c7d1c82f9c864f09c4097ea987565d387cfded"
    sha256 cellar: :any, x86_64_linux: "e113b5ac71c073b35ef96498d7df94c01d5515c102165d7304c3b94cbfc1dcd1"
  end

  depends_on "lld" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
