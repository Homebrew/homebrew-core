class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects"
  homepage "https://fedorahosted.org/elfutils/"
  url "https://sourceware.org/elfutils/ftp/0.195/elfutils-0.195.tar.bz2"
  sha256 "37629fdf7f1f3dc2818e138fca2b8094177d6c2d0f701d3bb650a561218dc026"
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
    rebuild 1
    sha256 arm64_linux:  "346c72d916a92418a5a6c3ff9280827fc0308ae167b7813874324bed636e5c8b"
    sha256 x86_64_linux: "47ab4bab0b24c5c61246126e25d7975bf02d5263e7b9e2df4d43be9f2c2870d4"
  end

  depends_on "m4" => :build
  depends_on "pkgconf" => :build
  depends_on "bzip2"
  depends_on :linux
  depends_on "xz"
  depends_on "zlib-ng-compat"
  depends_on "zstd"

  def install
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
