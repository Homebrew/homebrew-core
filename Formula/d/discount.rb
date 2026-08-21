class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-3.0.1.3.tar.bz2"
  sha256 "a4e3d4ead2412905b9d07954331cfde30c30743c5e0e4c57f40b3c2659efa30e"
  license "BSD-3-Clause"
  head "https://github.com/Orc/discount.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?discount[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c3ac17d7c61488e623460e15a5f68aa551861cd74b4703f17639e5f4b7f2883"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8d7862110dcd83e16019616bec578ac420dc83e3114506947733e904f8d4067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d21f1ab8ca4ae336665b9f26d7757d8df71bbca06c8f06c367a231e747b998f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9877be726ce44371afc6e976c86dc6dca73cd0b6826ae65cfafcf0d193873aa1"
    sha256 cellar: :any,                 arm64_linux:   "26f4c497eb1e707ed06fe69a4037e21224f6e887fda8935f7827fb973240df6e"
    sha256 cellar: :any,                 x86_64_linux:  "beacb5c0d8983547323c500b029f4e1657a7d02abce4225e263a576ca3579972"
  end

  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "multimarkdown", because: "both install `markdown` binaries"

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # Shared libraries are currently not built because they require
    # root access to build without patching.
    # Issue reported upstream here: https://github.com/Orc/discount/issues/266.
    # Add --shared to args when this is resolved.
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-dl=Both
      --enable-dl-tag
      --enable-pandoc-header
      --enable-superscript
      --pkg-config
    ]
    system "./configure.sh", *args
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make", "install.everything"
  end

  test do
    markdown = "[Homebrew](https://brew.sh/)"
    html = "<p><a href=\"https://brew.sh/\">Homebrew</a></p>"
    assert_equal html, pipe_output(bin/"markdown", markdown, 0).chomp
  end
end
