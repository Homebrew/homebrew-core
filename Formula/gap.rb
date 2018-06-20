class Gap < Formula
  desc "System for computational discrete algebra"
  homepage "https://www.gap-system.org/"
  url "https://www.gap-system.org/pub/gap/gap-4.9/tar.bz2/gap-4.9.1.tar.bz2"
  version "4.9.1"
  sha256 "d93abb263e6b9ce9f56bfb820ac263b9a0f349f6bd1584244c7b242931d0dd3a"

  depends_on "gmp"
  depends_on "readline"

  def install
    # Remove some unused files
    rm Dir["bin/*.bat", "bin/*.ico", "bin/*.bmp", "bin/cygwin.ver"]

    # Remove GMP archives (`gmp` formula is declared as a dependency)
    rm Dir["extern/gmp-*.tar.gz"]

    # XXX:  Currently there is no `install` target in `Makefile`.
    #   According to the manual installation instructions in
    #
    #     https://github.com/gap-system/gap/blob/master/INSTALL.md
    #
    #   the compiled "bundle" is intended to be used "as is," and there is
    #   no instructions for how to remove the source and other unnecessary
    #   files after compilation.  Moreover, the content of the
    #   subdirectories with special names, such as `bin` and `lib`, is not
    #   suitable for merging with the content of the corresponding
    #   subdirectories of `/usr/local`.  The easiest temporary solution seems
    #   to be to drop the compiled bundle into `<prefix>/libexec` and to
    #   create a symlink `<prefix>/bin/gap` to the startup script.
    #   This use of `libexec` seems to contradict Linux Filesystem Hierarchy
    #   Standard, but is recommended in Homebrew's "Formula Cookbook."

    libexec.install Dir["*"]

    # GAP does not support "make install" so it has to be compiled in place

    cd libexec do
      args = %W[--prefix=#{libexec} --with-gmp=system]
      system "./configure", *args
      system "make"
    end
    
    # Create a symlink `bin/gap` from the `gap` binary
    bin.install_symlink libexec/"gap" => "gap"

    ohai "Building included packages. Please be patient, it may take a while"
    cd libexec/"pkg" do
      # NOTE: This script will build most of the packages that require
      # compilation. It is known to produce a number of warnings and 
      # error messages, possibly failing to build several packages.
      system "../bin/BuildPackages.sh --with-gaproot=#{libexec}"
    end

  end

  test do
    (testpath/"test_input.g").write <<~EOS
      Print(Factorial(3), "\\n");
      Print(IsDocumentedWord("IsGroup"), "\\n");
      Print(IsDocumentedWord("MakeGAPDocDoc"), "\\n");
      QUIT;
    EOS
    test_output = shell_output("#{bin}/gap -b test_input.g")
    expected_output =
      <<-EOS.undent
        6
        true
        true
      EOS
    assert_equal expected_output, test_output
  end
end
