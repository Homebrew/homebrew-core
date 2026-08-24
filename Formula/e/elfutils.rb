class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects"
  homepage "https://fedorahosted.org/elfutils/"
  url "https://sourceware.org/elfutils/ftp/0.196/elfutils-0.196.tar.bz2"
  sha256 "fd5cc6b77ad6773cac93cb3f415f9318ac3b3455eecf801f6b4a742c4f6c7209"
  license all_of: [
    "GPL-3.0-or-later", # programs
    { any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"] }, # libraries
    "GFDL-1.3-no-invariants-or-later", # eu-readelf.1
  ]
  compatibility_version 1

  livecheck do
    url "https://sourceware.org/elfutils/ftp/"
    regex(%r{href=(?:["']?v?(\d+(?:\.\d+)+)/?["' >]|.*?elfutils[._-]v?(\d+(?:\.\d+)+)\.t)}i)
  end

  bottle do
    sha256 arm64_linux:  "2db7befa09c95783db45a7e6b01e2de442d40f8b0c917d2be8a4a851f49ccb12"
    sha256 x86_64_linux: "08c8a1c665c837f33394a6d488540aaf8477d2db5018fed28d4baa421764ac43"
  end

  depends_on "m4" => :build
  depends_on "pkgconf" => :build
  depends_on "bzip2"
  depends_on :linux
  depends_on "xz"
  depends_on "zlib-ng-compat"
  depends_on "zstd"

  def install
    # Kernel UAPI header redefines `struct iovec` as `lib/system.h` now includes <fcntl.h>
    # TODO: Fix is reported to upstream through email, check this is required or not in future releases.
    inreplace %w[backends/aarch64_initreg.c backends/arm_initreg.c], "<linux/uio.h>", "<sys/uio.h>"

    args = %w[
      --disable-silent-rules
      --disable-libdebuginfod
      --disable-debuginfod
      --with-bzlib
      --with-lzma
      --with-zlib
      --with-zstd
    ]
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    # Create temporary compatibility executables for previous Homebrew-specific names.
    # Remove them after 2 minor releases, i.e. 0.197
    odie "Remove compatibility scripts!" if version >= "0.197"
    bin.glob("eu-*") do |path|
      old_cmd = path.basename.to_s.sub("eu-", "elfutils-")
      (bin/old_cmd).write <<~SHELL
        #!/bin/bash
        echo "WARNING: #{old_cmd} has been renamed to #{path.basename}; #{old_cmd} will be removed in 0.197" >&2
        exec "#{path}" "$@"
      SHELL
    end
  end

  test do
    assert_match "elf_kind", shell_output("#{bin}/eu-nm #{bin}/eu-nm")
    assert_match "elf_kind", shell_output("#{bin}/elfutils-nm #{bin}/eu-nm")
  end
end
