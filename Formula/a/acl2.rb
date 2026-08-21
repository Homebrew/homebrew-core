class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/~moore/acl2/"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.7.tar.gz"
  sha256 "d6013c22e190cbd702870d296b5370a068c14625bf7f9d305d2d87292b594d52"
  license "BSD-3-Clause"
  revision 5

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "549486e442dd587ee33fca51e62c7219e0ec9c5a876b36ca1c698ad80f64832b"
    sha256 arm64_sequoia: "0ebafac056daae79af58bec06b832bfdf9e67ae8228ecec07a1545d753b1d1f2"
    sha256 arm64_sonoma:  "0666443724cc2c104730004c7353945585aa7837795c01623fef5188dbf924a7"
    sha256 sonoma:        "5459b341f7aa01dc8621dda02b62dd23cc906a2f2f110049a92d8e9d02e67bc1"
    sha256 x86_64_linux:  "78f5ebdbd00669a37371de5f08b89514529ad93c13703b1c602b7162a26b9362"
  end

  depends_on "sbcl"

  on_linux do
    # ACL2 rejects a Lisp that doesn't error on floating-point overflow
    depends_on arch: :x86_64
  end

  def install
    # Remove prebuilt binaries
    rm_r buildpath.glob("books/kestrel/axe/*/{examples,tests}")

    # Move files and then build to avoid saving build directory in files
    libexec.install Dir["*"]

    sbcl = Formula["sbcl"]
    args = ["LISP=#{sbcl.opt_bin}/sbcl", "USE_QUICKLISP=0", "ACL2_MAKE_LOG=NONE"]
    system "make", "-C", libexec, "all", "basic", *args
    system "make", "-C", libexec, "all", "basic", *args, "ACL2_PAR=p"

    ["acl2", "acl2p"].each do |acl2|
      inreplace libexec/"saved_#{acl2}", sbcl.prefix.realpath, sbcl.opt_prefix
      (bin/acl2).write_env_script libexec/"saved_#{acl2}", ACL2_SYSTEM_BOOKS: "#{libexec}/books"
    end
  end

  test do
    (testpath/"simple.lisp").write "(+ 2 2)"
    output = shell_output("#{bin}/acl2 < #{testpath}/simple.lisp | grep 'ACL2 !>'")
    assert_equal "ACL2 !>4\nACL2 !>Bye.", output.strip
  end
end
