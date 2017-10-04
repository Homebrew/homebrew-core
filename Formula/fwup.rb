class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.16.0/fwup-0.16.0.tar.gz"
  sha256 "5375421774d073773fb410a5152755a256a445d43d0bc0523ddf6c9d4657a4c2"

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
    assert File.exist?("fwup-key.priv"), "Failed to create fwup-key.priv!"
    assert File.exist?("fwup-key.pub"), "Failed to create fwup-key.pub!"
  end
end
