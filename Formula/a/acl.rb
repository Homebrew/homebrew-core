class Acl < Formula
  desc "Commands for manipulating POSIX access control lists"
  homepage "https://savannah.nongnu.org/projects/acl/"
  url "https://download.savannah.nongnu.org/releases/acl/acl-2.3.2.tar.gz"
  sha256 "5f2bdbad629707aa7d85c623f994aa8a1d2dec55a73de5205bac0bf6058a2f7c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.nongnu.org/releases/acl/"
    regex(/href=.*?acl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_linux:  "df5af5425e87eda102251eacdf2a56622bfbda1b285441d438186d471cbd4cb7"
    sha256 x86_64_linux: "65c9042358cb23a7510fb0a52f938e5b4e48d32c1a19c756165c6c814dd5146e"
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
