class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/~moore/acl2/"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"
  revision 15

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1206a65d92771cb92c143f845aea5d823cd51e9509c4a9634f81ca6dbc34093c"
    sha256 arm64_sequoia: "e1ea055ee9d9b0ca6390d588b36b87404f3db11adfc9b6d1a08bc9f739b8db3f"
    sha256 arm64_sonoma:  "33da5327235e954378f521c26627f0c340d07eab414fff7974373a1b30b68753"
    sha256 sonoma:        "19f12e7e0c35bfae87ee58e66f0ec527138e1aa88120b173acce226b4d3b3a1a"
    sha256 x86_64_linux:  "36e546567d2531e1d88437d92508f20bf5800e016b5ac7b48afa805a8168ac90"
  end

  depends_on "sbcl"

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
