class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "9745c86c9b832fd761e35e5baca5b429922475ef2430a387826d8434714fbbad"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "339e5e68486b120900b3d8be5e1661299a7c6aa774f7b303f049a12eb0a60f2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6545ffb758f834a85058c94c475302bfa1372d3df2993084742a7278d597db8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a74826325730ec889d60beff19952d292e9f4cb5a8a32dde0f91f8ae7d18d8c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "35ee8bdc6bf44055b6049460e6f8922f287c65434e40bf9a6571123c61a19caf"
    sha256 cellar: :any_skip_relocation, ventura:        "fcdf33dcb1f2b40b004b71ac71cbfa46db802bd191ee31d323da91d7ccc74a3f"
    sha256 cellar: :any_skip_relocation, monterey:       "0102cad04afa275cb51b0717733a800bec2152eda0746945ea1087cb1546f602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "848234c69c7b87e62a91b07c89d133817b3757e7b0260a3b318b497c80331a84"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "sqlite_omit_load_extension,sqlite_json"
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
