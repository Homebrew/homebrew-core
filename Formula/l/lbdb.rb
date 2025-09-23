class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb-0.56.tar.gz"
  sha256 "baa6a23b61394d792b7b221e1961d9ba5710614c9324e8f59b35c126c2b4e74e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.spinnaker.de/lbdb/download/"
    regex(/href=.*?lbdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2913b97578b062c2a723f248573db0509eb18092ad3dce167e1286183c11317a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fa1d425e1b6b4496d75679fefc7d0d0967ebc9c4654e495603c04950dd262ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf0613f346c74e4ac7f78c08297114d87b5b583f541768e8765a9ffffd55c3e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b613432087627ec2139888a3a2c7e024fd88fefee630e61e54a6048b8434ca22"
    sha256 cellar: :any_skip_relocation, sonoma:        "799de569aa9a50d882d5bb452351bc7fba0eb60f874024166a9696da6bd6ae40"
    sha256 cellar: :any_skip_relocation, ventura:       "e0f4a17ce22453b7aa2187bc18563bdc00aa05b65648523d5e9e944ce9c28f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec1911ba656b63107d2c2784b460c56781f35371e0b8895c86f9e645593d4bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f780ddee05060ddb5b7c9263c2a89d9ce686995f021df5b9eb610445c2709975"
  end

  depends_on "abook"
  depends_on "khard"

  def install
    system "./configure", "--libexecdir=#{lib}/lbdb", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/lbdbq -v")
    assert_path_exists lib/"lbdb/m_abook", "m_abook module is missing!"
    assert_path_exists lib/"lbdb/m_khard", "m_khard module is missing!"
  end
end
