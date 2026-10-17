class GhdlLlvm < Formula
  desc "Analyzer, compiler, simulator and (experimental) synthesizer for VHDL"
  homepage "https://ghdl.github.io/ghdl/"
  url "https://github.com/ghdl/ghdl/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "2d84fbd0b238a26928e89a0256274072c6b40af1969a4f4c7be57ec3515bc622"
  license "GPL-2.0-only"

  # essentiall copied from: https://github.com/ghdl/ghdl/blob/master/.github/workflows/Build-MacOS.yml

  depends_on "llvm@21" => :build # version 6.0.0 needs an older version of llvm

  depends_on "gnat"

  def install
    gnat_bin_path = formula_opt_bin("gnat")
    # gnat_lib_path = formula_opt_lib("gnat")/"gnat/current"

    # Configure environment
    ENV.prepend_path "PATH", formula_opt_bin("llvm@21") # use the same llvm as above
    # ENV.prepend_path "PATH", gnat_bin_path
    libzstd = "#{formula_opt_lib("zstd")}/libzstd.a"
    llvm_config = `llvm-config --link-static --libfiles --system-libs | sed -e s@-lzstd@#{libzstd}@`
    ENV["LLVM_LDFLAGS"] = "#{llvm_config} -Wl,-dead_strip,-dead_strip_dylibs"
    nproc = `sysctl -n hw.logicalcpu`
    ENV["GNATMAKE"] = "#{gnat_bin_path}/gnatmake -j#{nproc}"
    ENV["MAKE"] = "make -j#{nproc}"

    # build and install
    system "./configure", "--prefix=#{prefix}", "--with-llvm-config"
    system "make"
    system "make", "install"
  end

  test do
    # check if ghdl is running (at all)
    system bin/"ghdl", "--version"

    # create a simple VHDL
    (testpath/"test.vhd").write <<~VHDL
      library IEEE;
      use IEEE.STD_LOGIC_1164.ALL;
      entity test is
      end entity;

      architecture test_arch of test is
        -- definitions
      begin
        -- implementation
      end test_arch;
    VHDL

    # test the most important stages
    system bin/"ghdl", "-a", "test.vhd" # analyze
    system bin/"ghdl", "make", "test"   # build
    system bin/"ghdl", "run", "test", "--vcd=dump.vcd", "--wave=wave.ghw"

    # do not run official tests as they will trigger a timeout
    <<-OFFICIAL_TESTS
      # same as version used at top
      resource "ghdl sources" do
        url "https://github.com/ghdl/ghdl/archive/refs/tags/v6.0.0.tar.gz"
        sha256 "2d84fbd0b238a26928e89a0256274072c6b40af1969a4f4c7be57ec3515bc622"
      end

      resource("ghdl sources").stage do
        ENV.prepend_path "PATH", "/opt/homebrew/opt/coreutils/libexec/gnubin"
        ENV["GHDL"] = "#{bin}/ghdl"
        cd "testsuite"
        system "./testsuite.sh", "sanity"
      end
    OFFICIAL_TESTS
  end
end
