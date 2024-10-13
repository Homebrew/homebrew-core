class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb-0.54.tar.gz"
  sha256 "1579c38655d5cf7e2c6ca8aabc02b6590c8794ef0ae1fbb0c4d99226ffce5be7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.spinnaker.de/lbdb/download/"
    regex(/href=.*?lbdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3e7842c58647db76024d6190006df63c89ba288345fafd1a8f60b766d217da0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be9937a2767a3912fa32ef9c29355603ee74fba343d2853f27c9670ac7e6b276"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1e41b9735e02227ae4fb6d111a00542e65fa91bfd2c85f04f5b81799562f22b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfcd28b6fddeb64d97d8dd8e52dca156b3a1526bf5024c4ed0768e3e73e92b69"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccaf64124b63207fe3b2d7c59473e405becde367174cdc14d0047fcbe5f15a1f"
    sha256 cellar: :any_skip_relocation, ventura:        "0744d37e7b5b5bdde2b75a10b41f6e78ef00d4f81ded91fcb36af85c35729411"
    sha256 cellar: :any_skip_relocation, monterey:       "7a75bff4a9c752e3171c8f7b97cc3d2ce469dc4065c842578965ff83e8c72c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f6c94491fec0cc6a020978ad12096d98b181a6dca7541117c94a7ab31c9f5e"
  end

  depends_on "abook"
  depends_on "khard"

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/lbdbq -v")
    assert_predicate lib/"lbdb/m_abook", :exist?, "m_abook module is missing!"
    assert_predicate lib/"lbdb/m_khard", :exist?, "m_khard module is missing!"
  end
end
