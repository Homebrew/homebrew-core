class Crm114 < Formula
  desc "Examine, sort, filter or alter logs or data streams"
  homepage "https://sourceforge.net/projects/crm114/"
  url "http://deb.debian.org/debian/pool/main/c/crm114/crm114_20100106.orig.tar.gz"
  sha256 "fb626472eca43ac2bc03526d49151c5f76b46b92327ab9ee9c9455210b938c2b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bdadfd33ce2fbca99f2c353e6a59651f68de4353cf8ba8ec319986a39531e3d5"
    sha256 cellar: :any,                 arm64_sonoma:   "02293e7f49287e46515f25f788207339c207a9caed0b57c31853b691a9e0358c"
    sha256 cellar: :any,                 arm64_ventura:  "9791c36069114cb7235007258500b450c2d28aec42bc0753fae806bb2ef71dd4"
    sha256 cellar: :any,                 arm64_monterey: "0cdce09555c1d90f1e577367c906921bbd8ea8fb37af61598a8ec80307fe7bf5"
    sha256 cellar: :any,                 arm64_big_sur:  "24d3e83ee6c91b1fbed3b83aefbd17c2a93119b12d6cf7a9cea10090e52af6a8"
    sha256 cellar: :any,                 sonoma:         "12d3f28c5983f5db9162b528870730c5f05fdd10427ffa679bb3d00850208a94"
    sha256 cellar: :any,                 ventura:        "df00326ae71fa1bca46f3d78d63ad58b99346c3603b6bd7c6e95f5940c0705b5"
    sha256 cellar: :any,                 monterey:       "6ba9e53e2cbfd76a236595fff2cd7d0bd816dd41c4b48ec3e7d673bf12a40f69"
    sha256 cellar: :any,                 big_sur:        "c00ea54f01bfa748d4a48123c7140fd4e8abb200b8c42ca0ab016272f72eeb8c"
    sha256 cellar: :any,                 catalina:       "f6ebd35ffbae26d9cf77de3f165c13ec170b8123d527369f43e9a862f14eb287"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "56e301508f1430b1797bed7cce7c08b449b8b6064a8e73fc1f6f238688a2b49b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "159ba6e29e2da48573b2305e5d8afa7e6cb5806337fa6e2dc4375f8f77d781ca"
  end

  # The homepage has disappeared along with the `stable` tarball and the
  # SourceForge project only contains files from 2002-2004.
  deprecate! date: "2024-07-24", because: :unmaintained
  disable! date: "2025-07-26", because: :unmaintained

  depends_on "tre"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    ENV.append "CFLAGS", "-fcommon" if OS.linux?
    inreplace "Makefile", "LDFLAGS += -static -static-libgcc", ""
    bin.mkpath
    system "make", "prefix=#{prefix}", "install"
  end
end
