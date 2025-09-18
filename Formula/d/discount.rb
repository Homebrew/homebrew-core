class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-3.0.1.2.tar.bz2"
  sha256 "ec670ca34fba6dd99cf30170b98f57fbd84ed51528cc3ae732b5ec298e738d9d"
  license "BSD-3-Clause"
  head "https://github.com/Orc/discount.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?discount[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53803cc185bc57647a2ec9cac0bf8ed0d12c925f64dea3eed62e9840c9db1bce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8f498e3b95800f7ee24c4319506d4ccd4fca6973405ae1681d6f64f6c262e0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d8aea3828d1013f7e52ad43607e781f8d6afb5cfe40ab434f26bd49f9a0e545"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "565696d059a7e00a44a67c5e7fdadd7daa45f19e92edbc371d4ad66df2a94211"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4c0c639fa731507a166bbe8e6697b0f22abca9ce446bd30f8eaeeb9406240a2"
    sha256 cellar: :any_skip_relocation, ventura:       "3677d12c169e557d8cf391698826fbc0ccaf4695a582f224c7cc4e7a4e20a496"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8bfa31fc02e76df99bd7b31fbc81805217396662a0894d2f7a7fe5e3f67c368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f6c76ead3a6e1c9e20f28b7774494aef4d3f8b5d9ac1f4cbf389e72adac5023"
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
