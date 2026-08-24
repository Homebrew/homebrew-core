class Acl < Formula
  desc "Commands for manipulating POSIX access control lists"
  homepage "https://savannah.nongnu.org/projects/acl/"
  url "https://download.savannah.nongnu.org/releases/acl/acl-2.4.0.tar.gz"
  sha256 "73c853c3d44e1f693e5a96a986f1bd19d3d0dac2c7d453e796177774bc4e5f6a"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.nongnu.org/releases/acl/"
    regex(/href=.*?acl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "48bae129ac5466a87580baa10d4c9fa6e371767b7d0d86380c25d6f642a4d64f"
    sha256 x86_64_linux: "cf320c35f8f78b11ae1d7dfcf0dcc8e4f532755ecb13d346cffa363e5eef7f2b"
  end

  depends_on "attr" => :build
  depends_on :linux

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_equal "getfacl #{version}", shell_output("#{bin}/getfacl --version").chomp

    touch testpath/"test.txt"
    chmod 0654, testpath/"test.txt"
    assert_equal <<~EOS, shell_output("#{bin}/getfacl --omit-header test.txt").chomp
      user::rw-
      group::r-x
      other::r--
    EOS

    user = ENV["USER"]
    system bin/"setfacl", "--modify=u:#{user}:x", "test.txt"
    assert_equal <<~EOS, shell_output("#{bin}/getfacl --omit-header test.txt").chomp
      user::rw-
      user:#{user}:--x
      group::r-x
      mask::r-x
      other::r--
    EOS

    system bin/"chacl", "u::rwx,g::rw-,o::r-x", "test.txt"
    assert_equal <<~EOS, shell_output("#{bin}/getfacl --omit-header test.txt").chomp
      user::rwx
      group::rw-
      other::r-x
    EOS

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <sys/acl.h>

      int main() {
        acl_t acl = acl_get_file("test.txt", ACL_TYPE_ACCESS);
        if (acl == NULL) return 1;
        char* acl_text = acl_to_text(acl, NULL);
        acl_free(acl);
        printf("%s\\n", acl_text);
        acl_free(acl_text);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lacl"
    assert_equal <<~EOS, shell_output("./test").chomp
      user::rwx
      group::rw-
      other::r-x
    EOS
  end
end
