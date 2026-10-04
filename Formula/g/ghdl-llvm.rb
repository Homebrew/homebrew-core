class GhdlLlvm < Formula
  desc "Analyzer, compiler, simulator and (experimental) synthesizer for VHDL"
  homepage "https://ghdl.github.io/ghdl/"
  url "https://github.com/ghdl/ghdl/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "2d84fbd0b238a26928e89a0256274072c6b40af1969a4f4c7be57ec3515bc622"
  license "GPL-2.0-only"

  # essentiall copied from: https://github.com/ghdl/ghdl/blob/master/.github/workflows/Build-MacOS.yml

  depends_on "llvm@21" => :build # version 6.0.0 needs an older version of llvm

  # Define GNAT as a resource for better caching and management
  resource "gnat" do
    on_macos do
      on_arm do
        url "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-16.1.0-1/gnat-aarch64-darwin-16.1.0-1.tar.gz"
        sha256 "657cf254323eb91f79768918e8bd8887d6da7ac6056732a38f21e2848267da18"
      end
      on_intel do
        url "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-16.1.0-1/gnat-x86_64-darwin-16.1.0-1.tar.gz"
        sha256 "bb6d1434dc8850d7c6523eb455ab27f1f94eb760222c6c8acd540631e3f629bb"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-16.1.0-1/gnat-aarch64-linux-16.1.0-1.tar.gz"
        sha256 "8e297497f2d6d6845920a363a277b6ef5bc454e48a66d0d606b89d71e31ee623"
      end
      on_intel do
        url "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-16.1.0-1/gnat-x86_64-linux-16.1.0-1.tar.gz"
        sha256 "9f74f58a827a2ad40dd84c72a413e75ea52888e0d8f7e252fba4d26762402703"
      end
    end
  end

  def install
    # Download and extract GNAT using the resource block
    resource("gnat").stage do
      mkdir "#{buildpath}/gnat"
      `mv ./* #{buildpath}/gnat/`
      ENV["GNAT_BINARY_PATH"] = "#{buildpath}/gnat/bin"
    end

    # Configure environment
    ENV.prepend_path "PATH", formula_opt_bin("llvm@21") # use the same llvm as above
    ENV.prepend_path "PATH", ENV["GNAT_BINARY_PATH"]
    libzstd = "#{formula_opt_lib("zstd")}/libzstd.a"
    llvm_config = `llvm-config --link-static --libfiles --system-libs | sed -e s@-lzstd@#{libzstd}@`
    ENV["LLVM_LDFLAGS"] = "#{llvm_config} -Wl,-dead_strip,-dead_strip_dylibs"
    ENV["NPROC"] = `sysctl -n hw.logicalcpu`
    ENV["GNATMAKE"] = "gnatmake -j#{ENV["NPROC"]}"
    ENV["MAKE"] = "make -j#{ENV["NPROC"]}"

    # idk why, but somehow brew builds for macOS 28.0 on macOS 27.0
    macos_version = `xcrun --show-sdk-version`
    macos_version.strip!
    ENV["MACOSX_DEPLOYMENT_TARGET"] = macos_version
    puts "MACOSX_DEPLOYMENT_TARGET='#{ENV["MACOSX_DEPLOYMENT_TARGET"]}'"

    # build and install
    system "./configure", "--prefix=#{prefix}", "--with-llvm-config"
    system "make"
    system "make", "install"
    `install -m 755 -p #{ENV["GNAT_BINARY_PATH"]}/../lib/libgcc_s.*.*.dylib #{prefix}/bin/`
    `install -m 755 -p #{ENV["GNAT_BINARY_PATH"]}/../lib/libgcc_s.*.*.dylib #{prefix}/lib/`
    `install -m 755 -p \
      #{ENV["GNAT_BINARY_PATH"]}/../lib/gcc/*-apple-darwin*/*.*/adalib/libgnat-*.dylib \
      #{prefix}/lib/`

    # we do not want to link everything
    mv bin, libexec

    # now link only the relevant ones
    ghdlbins = ["ghdl", "ghwdump", "ghdl1-llvm"]
    ghdlbins.each do |ghdl_bin|
      bin.install_symlink "#{prefix}/libexec/#{ghdl_bin}"
    end
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
