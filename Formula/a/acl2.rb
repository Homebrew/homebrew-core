class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/~moore/acl2/"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"
  revision 11

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4fa4af1bf7a6789189a65b442b77cc995399e4c886db59b9a2632910416ad5ff"
    sha256 arm64_sequoia: "8b0a7d1318fbc019b8d9992174fd8f40819b334af0d1e603c3387f32ac320ee5"
    sha256 arm64_sonoma:  "811d34309d0651f364c26c3f44960a467722d1cb739ac5b03675bd4fecc1c36b"
    sha256 arm64_ventura: "9f65deddaa1bd314348c6b0fb13056e3b116a8f107f47883e9354e0ab359d4c1"
    sha256 sonoma:        "4b760f5beb1f7946ebc36bd5ef5fd5afa04233d6cb1a9a3af7f2b63e717c1a98"
    sha256 ventura:       "cb4ccdaf97ac46ace26fb9a17f09ddf8d6a658d6167e68aa0e614afe04a85138"
    sha256 arm64_linux:   "df5a6da5de6d1f5e63d5de4dc786cd6a7acfee032428e6ae2ef1d2ed81bd2f39"
    sha256 x86_64_linux:  "df5a6da5de6d1f5e63d5de4dc786cd6a7acfee032428e6ae2ef1d2ed81bd2f39"
  end

  depends_on "sbcl"

  def install
    # Remove prebuilt binaries
    rm([
      "books/kestrel/axe/x86/examples/popcount/popcount-macho-64.executable",
      "books/kestrel/axe/x86/examples/factorial/factorial.macho64",
      "books/kestrel/axe/x86/examples/tea/tea.macho64",
    ])

    # Move files and then build to avoid saving build directory in files
    libexec.install Dir["*"]

    sbcl = Formula["sbcl"].opt_bin/"sbcl"
    begin
      system "make", "-C", libexec, "all", "basic", "LISP=#{sbcl}", "USE_QUICKLISP=0"
      system "make", "-C", libexec, "all", "basic", "LISP=#{sbcl}", "USE_QUICKLISP=0", "ACL2_PAR=p"
    rescue
      logs.install libexec/"make.log"
      raise
    end

    ["acl2", "acl2p"].each do |acl2|
      inreplace libexec/"saved_#{acl2}", Formula["sbcl"].prefix.realpath, Formula["sbcl"].opt_prefix
      (bin/acl2).write_env_script libexec/"saved_#{acl2}", ACL2_SYSTEM_BOOKS: "#{libexec}/books"
    end
  end

  test do
    (testpath/"simple.lisp").write "(+ 2 2)"
    output = shell_output("#{bin}/acl2 < #{testpath}/simple.lisp | grep 'ACL2 !>'")
    assert_equal "ACL2 !>4\nACL2 !>Bye.", output.strip
  end
end
