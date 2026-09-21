class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-3.0.2.0.tar.bz2"
  sha256 "4747d9e745c2bb6fc0f2cf24ebf27d8f5cc61d08c01fafa54db419b604f1b674"
  license "BSD-3-Clause"
  head "https://github.com/Orc/discount.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?discount[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d32ed065e9a8afcaacd8a6aa07b8bfe1c0b1a4c75186722053664d24874c1cbf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ecfba03c385202b0e8b5978490e902a9ea0bfaa931f335b0373f06e307bfd1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1de360ac09c26dae01e75c91be82789089e5b12b12a631d3f772cc8f7ad87ad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6a1adcfef63d8392fc4afc07b7f7966ce179fec47307a72aea2f2090fb19eb90"
    sha256 cellar: :any,                 arm64_linux:       "2e5e88312f78946d2952ae051bfb3616ac53d21e5890bcd4c7d72fa0cb30447d"
    sha256 cellar: :any,                 x86_64_linux:      "12ead269cf940203e11c955208f1be1490ff357fe2754240d59b993d563530ec"
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
