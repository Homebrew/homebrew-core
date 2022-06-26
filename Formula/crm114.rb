class Crm114 < Formula
  desc "Examine, sort, filter or alter logs or data streams"
  homepage "https://crm114.sourceforge.io/"
  url "https://crm114.sourceforge.io/tarballs/crm114-20100106-BlameMichelson.src.tar.gz"
  sha256 "fb626472eca43ac2bc03526d49151c5f76b46b92327ab9ee9c9455210b938c2b"

  livecheck do
    url "https://crm114.sourceforge.io/wiki/doku.php?id=download"
    regex(%r{href=.*?/crm114[._-]v?(\d+(?:\.\d+)*)[._-]([a-z]+)?\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0cdce09555c1d90f1e577367c906921bbd8ea8fb37af61598a8ec80307fe7bf5"
    sha256 cellar: :any,                 arm64_big_sur:  "24d3e83ee6c91b1fbed3b83aefbd17c2a93119b12d6cf7a9cea10090e52af6a8"
    sha256 cellar: :any,                 monterey:       "6ba9e53e2cbfd76a236595fff2cd7d0bd816dd41c4b48ec3e7d673bf12a40f69"
    sha256 cellar: :any,                 big_sur:        "c00ea54f01bfa748d4a48123c7140fd4e8abb200b8c42ca0ab016272f72eeb8c"
    sha256 cellar: :any,                 catalina:       "f6ebd35ffbae26d9cf77de3f165c13ec170b8123d527369f43e9a862f14eb287"
    sha256 cellar: :any,                 mojave:         "38a8c208a23dc67027eb63e9a8a6782cdb0763caa061fbf74525003d028d0558"
    sha256 cellar: :any,                 high_sierra:    "1871f19d45d9d9d5f84663acde3f7e9177fd9a44bfe50532ed123314e360f690"
    sha256 cellar: :any,                 sierra:         "5e22ac9266e49f8281f3afbd613b3f16eb76113fc1f1e2256206513ab6220d42"
    sha256 cellar: :any,                 el_capitan:     "d48449acfcd105d07e11c0ac7c47fdb21b88d3346c0b51377b9e44b8c8726073"
    sha256 cellar: :any,                 yosemite:       "151316bd14f7cfce5cea3b765cf4e7801e31c63b72dd786fb38989d8b9380eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "159ba6e29e2da48573b2305e5d8afa7e6cb5806337fa6e2dc4375f8f77d781ca"
  end

  depends_on "tre"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    inreplace "Makefile", "LDFLAGS += -static -static-libgcc", ""
    bin.mkpath
    system "make", "prefix=#{prefix}", "install"
  end
end
