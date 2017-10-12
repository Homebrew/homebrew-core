class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.16.1/fwup-0.16.1.tar.gz"
  sha256 "4c53a3c25c2e7c55a3a4d73f56c819213260b16b68964a774457349c559fef49"

  bottle do
    cellar :any
    sha256 "6519560162fd726a35ad9faeaacc2d177de4a00594e9a091ba640dac4eb9b5ed" => :high_sierra
    sha256 "af6ad960d4dd6683a353c1ea5ec32463a9d71141599eaa32bd290fc25a534e64" => :sierra
    sha256 "fc27958f4c66b4d401c78693e10342c1d930ae5d533a26dee767144abd3c7fff" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
