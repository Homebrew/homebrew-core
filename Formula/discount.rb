class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.7b.tar.bz2"
  sha256 "b9368cc2063831635f9e790d0c4c338c2b4b72658cdc244323241bfcddf6ffd5"
  license "BSD-3-Clause"
  head "https://github.com/Orc/discount.git", branch: "main"

  # We check the upstream GitHub repository because the homepage doesn't always
  # update to list the latest version in a timely manner. As of writing, the
  # homepage has been showing an older version for months, so it doesn't seem
  # like a reliable source for the latest version information, unfortunately.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03a512e21fb2f05d4d2e35e5b3f75199a61e0fa2ed44f7461c9405caa694a73c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47ced80d8c7d86e2621ec51d2c0a4f6a8908c6b411809f14ad8ada82c58d73fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78123c680c39668f0d37eeebe400ad5314fc78f4df38076aa77dd7e69eb67c38"
    sha256 cellar: :any_skip_relocation, ventura:        "8eeb94fd9c35339a0282c884eab1f11bb535274128a9e836f00406e41ee6d970"
    sha256 cellar: :any_skip_relocation, monterey:       "dd4569f09f12e8f69b39fa4cd2813515b050a228465549298409f6fe9fc24d3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3be94be78ab2d85a8503f893527c62efe438ca127873d0a03336e9e131a2783b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17289c8fe47a7c9f6b3cd8a5d79a608c382402abeeed6fc9b9c2ad4de4178dd8"
  end

  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "multimarkdown", because: "both install `markdown` binaries"

  def install
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
