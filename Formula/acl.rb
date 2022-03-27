class Acl < Formula
  desc "Commands for manipulating POSIX access control lists"
  homepage "https://savannah.nongnu.org/projects/acl/"
  url "https://download.savannah.nongnu.org/releases/acl/acl-2.3.1.tar.gz"
  sha256 "760c61c68901b37fdd5eefeeaf4c0c7a26bdfdd8ac747a1edff1ce0e243c11af"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.nongnu.org/releases/acl/"
    regex(/href=.*?acl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "attr"
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

    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lacl"
    assert_equal <<~EOS, shell_output("./test").chomp
      user::rwx
      group::rw-
      other::r-x
    EOS
  end
end
