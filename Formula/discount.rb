class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.7.tar.bz2"
  sha256 "b1262be5d7b04f3c4e2cee3a0937369b12786af18f65f599f334eefbc0ee9508"
  license "BSD-3-Clause"
  head "https://github.com/Orc/discount.git"

  # We check the upstream GitHub repository because the homepage doesn't always
  # update to list the latest version in a timely manner. As of writing, the
  # homepage has been showing an older version for months, so it doesn't seem
  # like a reliable source for the latest version information, unfortunately.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "013c9e0bedb1a10f099e3b9a0c521c7e2f287602ae101284fc8d5bcbe76abfbf" => :big_sur
    sha256 "6eb8a216722f471eb6475f13e7f02a079069667d9c428b93275a7424aaea9a75" => :arm64_big_sur
    sha256 "dcec657eb504394b83d9d949f3e33463733a4410681d38826040aaf9084f8ed5" => :catalina
    sha256 "a5848add43adaee78666b9fc29de442944066e6bcbf7d547b68346dfa665c65f" => :mojave
  end

  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "multimarkdown", because: "both install `markdown` binaries"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-dl=Both
      --enable-dl-tag
      --enable-pandoc-header
      --enable-superscript
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
