class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.9.1/fwup-1.9.1.tar.gz"
  sha256 "fc76f74dadbde53cdc9786737983f9dcdd7da3dbcc4dbd683404c8e136112741"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "efb4d1812874d9aafc14cc182f9845f532ab07c61d15b0e64f93db2a3da9d281"
    sha256 cellar: :any,                 arm64_big_sur:  "7619546ff2c4b4ed240742537a401e2dfee974ddbcdd791e447e43df77dca91e"
    sha256 cellar: :any,                 monterey:       "58f6ff63d19cd1d365f9956ec6f7ef81da32af71e22b35a4629a3de6c334b0d3"
    sha256 cellar: :any,                 big_sur:        "b5782437e98337b35e9b1a652e05282e7c48bc70b30e69aebc2d715a3f604fce"
    sha256 cellar: :any,                 catalina:       "ca4c2eb6a2b97bb54914b86517f7bb51f16b72eb59511e118e7c989fce402df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c4e711f5c0929c83c151c1ee4e4d11920317b73d1edb3308938f13161d5a72"
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

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
