class Gap < Formula
  desc "System for computational discrete algebra"
  homepage "https://www.gap-system.org/"
  url "https://www.gap-system.org/pub/gap/gap48/tar.bz2/gap4r8p9_2017_12_18-23_44.tar.bz2"
  version "4.8.9"
  sha256 "4c5a5bbbdb5275213cc575174f7bfb8bfd61c12bd082770798162b2ae6ac577d"

  bottle do
    cellar :any
    sha256 "714ba2f943796f16be21d9dd7ac562873c481c38d8a47620f99b8571c19a25f7" => :high_sierra
    sha256 "b745466b7b76c750b79d00f9ca6c47c154a0a2e18988caf4fcd8bd15c282697d" => :sierra
    sha256 "fdaf283fb6c9657dc75e142b957759bc63c5b9a81f5545564df1b030ccb83564" => :el_capitan
    sha256 "9eca000ecddafb1101edb06cd6087f87e38f9d168d5224e8c7030ccf6bf85853" => :x86_64_linux
  end

  # NOTE:  the archive contains the [GMP library](https://gmplib.org/) under
  #   `extern/`, which is not needed if it is already installed (for example,
  #   with Homebrew), and a number of GAP packages under `pkg/`, some of
  #   which need to be built.

  option "with-packages",
         "Try to build included packages using BuildPackages script"

  deprecated_option "with-InstPackages" => "with-packages"

  depends_on "gmp"
  # NOTE:  A version of [GMP](https://gmplib.org/) is included in GAP archive
  #   under `extern/`, it is possible to use it instead of the brewed `gmp`.
  #   See https://www.gap-system.org/Download/INSTALL for details.

  depends_on "readline" => :recommended

  def install
    # Remove some useless files
    rm Dir["bin/*.bat", "bin/*.ico", "bin/*.bmp", "bin/cygwin.ver"]

    # Remove GMP archives (`gmp` formula is declared as a dependency)
    rm Dir["extern/gmp-*.tar.gz"]

    # XXX:  Currently there is no `install` target in `Makefile`.
    #   According to the manual installation instructions in
    #
    #     https://www.gap-system.org/Download/INSTALL ,
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

    args = %W[--prefix=#{libexec} --with-gmp=system]

    args << "--#{build.with?("readline") ? "with" : "without"}-readline"
    # NOTE: `--with-readline` is the default, it is included for clarity

    system "./configure", *args

    # Fix a bug caused by the buggy `configure` which does not respect
    # `--prefix` when generating the startup script: the variable `GAP_DIR`
    # is being set to the (temporary) build directory, but should be set to
    # the value of `--prefix` option.
    ["bin/gap-default32.sh", "bin/gap-default64.sh"].each do |startup_script|
      next unless File.exist?(startup_script)
      inreplace startup_script, /^GAP_DIR="[^"]*"$/,
                                        "GAP_DIR=\"#{libexec}\""
    end

    system "make"

    libexec.install Dir["*"]

    # Create a symlink `bin/gap` from the symlink `gap.sh`
    cd libexec/"bin" do
      # NOTE: the symbolic link `gap.sh` is (or may be) relaive
      bin.install_symlink File.expand_path(`readlink -n gap.sh`) => "gap"
    end

    if build.with? "packages"
      ohai "Trying to automatically build included packages"
      cd libexec/"pkg" do
        # NOTE:  running this script is known to produce a number of error
        #   messages, possibly failing to build certain packages
        system "../bin/BuildPackages.sh"
      end
    end
  end

  # XXX:  `brew info` displays the caveats according to the options it is
  #   given, not according to the options with which the formula is installed
  def caveats
    if build.without?("packages")
      <<-EOS.undent
        If the formula is installed without the `--with-packages' option,
        some packages in:
          #{libexec/"pkg"}
        will need to be built manually with the following script:
          #{libexec/"bin/BuildPackages.sh"}
        See the Section 7 of #{libexec/"INSTALL"} for more info.
      EOS
    else
      <<-EOS.undent
        When the formula is installed with the `--with-packages' option,
        some packages in
          #{libexec/"pkg"}
        are automatically built using the following script:
          #{libexec/"bin/BuildPackages.sh"}
        However, this script is known to produce a number of error messages,
        and thus it might have failed to build certain packages.
      EOS
    end
  end

  test do
    File.open("test_input.g", "w") do |f|
      f.write <<-EOS.undent
        Print(Factorial(3), "\\n");
        Print(IsDocumentedWord("IsGroup"), "\\n");
        Print(IsDocumentedWord("MakeGAPDocDoc"), "\\n");
        QUIT;
      EOS
    end
    test_output = `#{bin/"gap"} -b test_input.g`
    assert_equal 0, $?.exitstatus
    expected_output =
      <<-EOS.undent
        6
        true
        true
      EOS
    assert_equal expected_output, test_output
  end
end
