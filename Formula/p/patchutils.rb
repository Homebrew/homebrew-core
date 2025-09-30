class Patchutils < Formula
  desc "Small collection of programs that operate on patch files"
  homepage "http://cyberelk.net/tim/software/patchutils/"
  url "http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.4.3.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/p/patchutils/patchutils_0.4.3.orig.tar.xz"
  sha256 "0efc96a9565fd156fc1064fdcc54c82b6229db0d402827c4c48b02f6ef956445"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "http://cyberelk.net/tim/data/patchutils/stable/"
    regex(/href=.*?patchutils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bf4589febeda90518d2d4d875a96f4c4a25316a80c7c1d1718e05c96d5eb101"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6a40f8058c158c1bc004362bb9fc905ef2fb7f0b3c1219a8fdcde2de8f19f37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad5ea66690eeeba9d66fc431e9ed5f839831ae39a5be14ed363e45f3ad3805c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02b054e5a449dac5daaf82ff1813498ef3e6155dec5498ef912daf232f169bb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4592cd1b0f1e0974000cd6d62e02a325abae667117985ebcdd8fec6a9700dc0"
    sha256 cellar: :any_skip_relocation, ventura:       "f13dff3b92a4a30d85ae6e7bb6ecc43a7671870281b22b66b57e886523400551"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b194dc23348077bf9093e8127bbf96faa783e8a83daabb46496b3799e6ba6f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5bc8b626210df1bb5f3e86d5cb731adfa03dbb8911186b5e424cc36ddbc573b"
  end

  head do
    url "https://github.com/twaugh/patchutils.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook" => :build
  end

  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./bootstrap" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match %r{a/libexec/NOOP}, shell_output("#{bin}/lsdiff #{test_fixtures("test.diff")}")
  end
end
