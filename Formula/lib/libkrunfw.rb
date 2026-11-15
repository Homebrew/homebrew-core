class Libkrunfw < Formula
  include Language::Python::Virtualenv

  desc "Dynamic library bundling the guest payload consumed by libkrun"
  homepage "https://github.com/libkrun/libkrunfw"
  url "https://github.com/libkrun/libkrunfw/archive/refs/tags/v5.6.4.tar.gz"
  sha256 "5b92b6f2a5ee6a16583bd37014a37794451a00d120fceee104f84404118757d0"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4aff0cffbad00d7db8bfc8740884eac1c2cf04d219a108f4786919fa983d69f0"
    sha256 cellar: :any, arm64_tahoe:       "b35cbe5f251df243be82e1a32ebe7a2c563d2218c53582ddd292e319930903a3"
    sha256 cellar: :any, arm64_sequoia:     "d48135d2fe214387aedc924654c54dadd7278db5a495f67b5ceb0fc8b6b026f5"
    sha256 cellar: :any, arm64_linux:       "4a7e9225a4a9105c40c4c0a3571bd94a2922d1468fe513822ff782c3c435e5dd"
    sha256 cellar: :any, x86_64_linux:      "0b9d3ad80fa343edcd5833a0a311c725182982df3a6a169c3488581510093aa5"
  end

  depends_on "python@3.15" => :build
  depends_on "xz" => :build

  uses_from_macos "bc" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "cpio" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "gnu-tar" => :build
    depends_on "libelf" => :build
    depends_on "lld" => :build
    depends_on "llvm" => :build
    depends_on "make" => :build

    fails_with :clang
  end

  on_linux do
    depends_on "elfutils" => :build
  end

  resource "kernel" do
    url "https://github.com/libkrun/linux/archive/refs/tags/v5.6.4-6.12.115.tar.gz", using: :nounzip
    sha256 "050fcea96b607e49f135f270472bc95346c172c9d6df5f9256aeb6f7972675d5"

    livecheck do
      url "https://raw.githubusercontent.com/libkrun/libkrunfw/refs/tags/v#{LATEST_VERSION}/Makefile"
      regex(/^KERNEL_VERSION\s*=\s*(\d+(:?\.\d+)+)$/i)
      strategy :page_match do |page, regex|
        full_version = page.match(/^FULL_VERSION\s*=\s*(\d+(:?\.\d+)+)$/i)[1]
        page.scan(regex).map do |match|
          "#{full_version}-#{match.first}"
        end
      end
    end
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/a3/11/767522582afab1b884d277de0e6e011640cb9d7292a38694b4b1a1df1ae8/pyelftools-0.33.tar.gz"
    sha256 "660d82dcbeb8e83d1702bd97f223f761625da06111c0cc988eac6b8ab0c1b61f"
  end

  # For Python
  allow_network_access! :build

  def install
    kernel_sources = "linux-#{resource("kernel").version}"
    kernel_binary = if Hardware::CPU.arm64?
      "#{kernel_sources}/arch/arm64/boot/Image"
    else
      "#{kernel_sources}/vmlinux"
    end
    resource("kernel").stage buildpath/"tarballs"
    mv buildpath/"tarballs/#{kernel_sources}.tar.gz", buildpath/"tarballs/v#{resource("kernel").version}.tar.gz"

    make_args = []
    make_args << "MACOS_BUILDER=native" if OS.mac?

    original_path = ENV["PATH"]

    kernel_make_args = []
    if OS.mac?
      # We bypass the Homebrew compiler shims by putting the desired
      # toolchain first on `PATH` (the upstream makefile passes it into kbuild).
      ENV.prepend_path "PATH", formula_opt_bin("lld")
      ENV.prepend_path "PATH", formula_opt_bin("llvm")
      # The kernel build also needs GNU sed, GNU tar, and GNU make.
      %w[gnu-sed gnu-tar make].each do |name|
        ENV.prepend_path "PATH", formula_opt_libexec(name)/"gnubin"
      end
    elsif OS.linux?
      # Remove the shims from `PATH` so that kbuild uses the system toolchain.
      ENV.remove "PATH", Superenv.shims_path
      # One side effect of bypassing the shims is that we need to help kbuild
      # find and use elfutils.
      kernel_make_args += [
        "HOSTCFLAGS=-I#{formula_opt_include("elfutils")}",
        "HOSTLDFLAGS=-L#{formula_opt_lib("elfutils")} -Wl,-rpath,#{formula_opt_lib("elfutils")}",
      ]
    end

    system "make", kernel_binary, *make_args, *kernel_make_args
    touch kernel_binary

    # Restore PATH after kernel build-specific overrides
    ENV["PATH"] = original_path

    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resource("pyelftools")
    ENV.prepend_path "PATH", venv.root/"bin"

    system "make", *make_args

    # Install to `lib` subdir instead of upstream default `lib64`
    install_args = ["PREFIX=#{prefix}"]
    install_args << "LIBDIR_Linux=lib" if OS.linux?
    system "make", "install", *install_args, *make_args
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <dlfcn.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main(int argc, char** argv) {
        void *handle = dlopen(argv[1], RTLD_LAZY);
        if (!handle) {
          fprintf(stderr, "dlopen: %s\n", dlerror());
          return 1;
        }
        void *sym = dlsym(handle, "krunfw_get_kernel");
        if (!sym) {
          fprintf(stderr, "dlsym: %s\n", dlerror());
          dlclose(handle);
          return 1;
        }
        printf("krunfw_get_kernel found at %p\n", sym);
        dlclose(handle);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test"
    system "./test", lib/shared_library("libkrunfw")
  end
end
