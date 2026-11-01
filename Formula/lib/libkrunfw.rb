class Libkrunfw < Formula
  include Language::Python::Virtualenv

  desc "Dynamic library bundling the guest payload consumed by libkrun"
  homepage "https://github.com/libkrun/libkrunfw"
  url "https://github.com/libkrun/libkrunfw/archive/refs/tags/v5.6.2.tar.gz"
  sha256 "df45d649fcbd07a4d0ca03fa836b2f640fdcf9b40187f3eb7023259c6e83d582"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8d4cd72051db87808843705c667a3c992d3a7a5d24ea268aece14b5577c901b7"
    sha256 cellar: :any, arm64_tahoe:       "bc287d2702399aeca644a9aa37c015e5294cb9f87ee7324f1f75230e2b4175ef"
    sha256 cellar: :any, arm64_sequoia:     "7ae8b88c80ed555bf2a71cc4eb3311db7e7c3b188fa3cb5b8b41694d1c8dfb33"
    sha256 cellar: :any, arm64_linux:       "a41c4c317993e54d90da89e221cc8621ad17e536a2a71b458e7c468eeb5b7643"
    sha256 cellar: :any, x86_64_linux:      "b3e1b3eab7d80456a75fc5e3e39d2cbef810d92ec2b45ae1b1c2520c08d4c0a6"
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
    url "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.12.109.tar.xz", using: :nounzip
    sha256 "5484e552a334e15019f4aeba89e5b58f04651cf2f4e24e04de9f152f1c38e3fa"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/a3/11/767522582afab1b884d277de0e6e011640cb9d7292a38694b4b1a1df1ae8/pyelftools-0.33.tar.gz"
    sha256 "660d82dcbeb8e83d1702bd97f223f761625da06111c0cc988eac6b8ab0c1b61f"
  end

  # For Python
  allow_network_access! :build

  def install
    resource("kernel").stage buildpath/"tarballs"
    kernel_sources = "linux-#{resource("kernel").version}"
    kernel_binary = if Hardware::CPU.arm64?
      "#{kernel_sources}/arch/arm64/boot/Image"
    else
      "#{kernel_sources}/vmlinux"
    end

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
    (testpath/"test.c").write <<~C
      #include <dlfcn.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main(void) {
        void *handle = dlopen("#{lib/shared_library("libkrunfw")}", RTLD_LAZY);
        if (!handle) {
          fprintf(stderr, "dlopen: %s\\n", dlerror());
          return 1;
        }
        void *sym = dlsym(handle, "krunfw_get_kernel");
        if (!sym) {
          fprintf(stderr, "dlsym: %s\\n", dlerror());
          dlclose(handle);
          return 1;
        }
        printf("krunfw_get_kernel found at %p\\n", sym);
        dlclose(handle);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
