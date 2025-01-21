class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.7d.tar.bz2"
  sha256 "12a2041e96ae8cde17e08ff1a215d331580a5c58688daa5a18842b6bb5b77b52"
  license "BSD-3-Clause"
  head "https://github.com/Orc/discount.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?discount[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a570a68edd737474736b516db39db9a072785ff13735f226d0cd8ea056648311"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14e2177eb0728e9d8690a7e6854250f174f5d988a046dd3f071c9beecf930540"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "130512a4b6b48f7dc9352cf9591b27f1f3083a2ff22d88e71f47507178a87e43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19bff1a2b50eae855a70eb7e6ed839f37891b9001f77780245a8c484b009a108"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49f9e9459165f07289b9e418e1db9398e94acd67fa480d50c2fc6951bd9f4bf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f4407e7dc8307e20dfcb377e033e194c4161ee7128214644065f7a7cb400982"
    sha256 cellar: :any_skip_relocation, ventura:        "aa3f9a506863629ddcb54c8f52193e4bcf55563d2ad0a6e610bb84b262dad679"
    sha256 cellar: :any_skip_relocation, monterey:       "698db890a09df9b32fdaa93ac1f178cfbaf497a5b93ede5380c00ea539bcbcc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1cfca46da847dcd5346cecf299b699b6f72826f3f5ab7a25ede643de3c26945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ec0cbcf4b9024c8f51ff944c335c2469b85082f8599b34b5b74046c9512afd2"
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
