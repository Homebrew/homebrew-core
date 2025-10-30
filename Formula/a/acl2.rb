class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/~moore/acl2/"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"
  revision 13

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "79f4d9fcd79ff956c2b698d4a0d1400506a9c83a032b3b675f67382c2e2ad805"
    sha256 arm64_sequoia: "dcb4361aebe67010a2b772fa08b00d05dce7f44e342101da07ce04fe3b4d41ed"
    sha256 arm64_sonoma:  "238c9edf710d6c268f15b57b0da402f900618c562df34d359e5727e95a03d4c6"
    sha256 sonoma:        "465e7552071a28adb773e85803c29193614d27fa020783e0a758d4fc1b7a1a99"
    sha256 x86_64_linux:  "0ae5f2bf2d53143d05ad171874894656618f1b10b23a2d7c5e43a461351aa6b9"
  end

  on_macos do
    depends_on "sbcl"
  end

  on_linux do
    # FP overflow trap isn't behaving as expected on GitHub runner so using `gcl` instead.
    # https://github.com/acl2/acl2/issues/1616#issuecomment-3448760740
    # https://github.com/jimwhite/acl2-jupyter/commit/6c062e8c5c02f996476c461fa18e464bf7c6ceea
    on_arm do
      # Use same tarball as Debian for gcl 2.7 fixes
      url "https://github.com/acl2/acl2/archive/refs/tags/post-8.6-for-debian-gcl.tar.gz"
      sha256 "d91d7cdc46812869d5be7fa393b1cbdbaa323250a6ed47a4a7ccf2623829903f"

      depends_on "gcl" => :build
      depends_on "gmp"
      depends_on "libtirpc"
    end
    on_intel do
      depends_on "sbcl"
    end
  end

  def install
    # Remove prebuilt binaries
    rm([
      "books/kestrel/axe/x86/examples/popcount/popcount-macho-64.executable",
      "books/kestrel/axe/x86/examples/factorial/factorial.macho64",
      "books/kestrel/axe/x86/examples/tea/tea.macho64",
      "books/kestrel/axe/x86/examples/tea/tea.elf64",
      "books/kestrel/axe/x86/examples/add/add.elf64",
    ])

    # Move files and then build to avoid saving build directory in files
    libexec.install Dir["*"]

    variants = ["acl2"]
    lisp = "sbcl"
    if OS.linux? && Hardware::CPU.arm?
      lisp = "gcl"
      ENV["ACL2_SNAPSHOT_INFO"] = "NONE" # TODO: remove in next release
      ENV["GCL_ANSI"] = "1"
      ENV.remove "PATH", Superenv.shims_path # FIXME: shims path is getting saved in binary
    else
      variants << "acl2p"
    end

    variants.each do |acl2|
      args = ["LISP=#{Formula[lisp].opt_bin/lisp}", "USE_QUICKLISP=0", "ACL2_MAKE_LOG=NONE"]
      args << "ACL2_PAR=p" if acl2 == "acl2p"
      system "make", "-C", libexec, "all", "basic", *args

      inreplace libexec/"saved_#{acl2}", Formula[lisp].prefix.realpath, Formula[lisp].opt_prefix if lisp == "sbcl"
      (bin/acl2).write_env_script libexec/"saved_#{acl2}", ACL2_SYSTEM_BOOKS: "#{libexec}/books"
    end
  end

  test do
    (testpath/"simple.lisp").write "(+ 2 2)"
    output = shell_output("#{bin}/acl2 < #{testpath}/simple.lisp | grep 'ACL2 !>'")
    assert_equal "ACL2 !>4\nACL2 !>Bye.", output.strip
  end
end
