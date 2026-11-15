class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/~moore/acl2/"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.7.tar.gz"
  sha256 "d6013c22e190cbd702870d296b5370a068c14625bf7f9d305d2d87292b594d52"
  license "BSD-3-Clause"
  revision 8

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "41c1ef280ad4c96320556635f25469d2dcffb8f82829a1e2755c8a7a0996d3cb"
    sha256 arm64_tahoe:       "b6d1d6340a2f29b640ec1a882190d663c91edb4111502d84ffacdec485519a82"
    sha256 arm64_sequoia:     "5cb97fed334c062ca4b2e837b09c70daf0979d167c394738ae14f6f6fe6f9d1c"
    sha256 x86_64_linux:      "83e6c02eb5c741e28a8020e9a029704980b2056977d512f1c3559eb03f63c455"
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
