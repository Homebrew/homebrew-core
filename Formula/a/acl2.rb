class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/~moore/acl2/"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.7.tar.gz"
  sha256 "d6013c22e190cbd702870d296b5370a068c14625bf7f9d305d2d87292b594d52"
  license "BSD-3-Clause"
  revision 6

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "876c1191c764794eaa49092618fe04f6aa37c2be7893240da7d389bd095c1a11"
    sha256 arm64_tahoe:       "78143826f951f09570c6322c57a1e050ecab473f06669a29ee454079575a09c2"
    sha256 arm64_sequoia:     "5d6cb354d886b5485c15ee1f846ea047854fbfe92791382f209c8db812fe906a"
    sha256 arm64_sonoma:      "6415333e59af5e96233aea4ecb4c83192353acae63902ae93d2bb65991dc1272"
    sha256 x86_64_linux:      "75dcfc87206f0977870b59e285aae2d96a5d52d0cba2c0b525fb70874d3ce72b"
  end

  depends_on "sbcl"

  on_linux do
    # ACL2 rejects a Lisp that doesn't error on floating-point overflow
    depends_on arch: :x86_64
  end

  deny_network_access!

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
    output = pipe_output(bin/"acl2", "(+ 2 2)", 0)
    assert_match "ACL2 !>4\nACL2 !>Bye.", output.strip
  end
end
