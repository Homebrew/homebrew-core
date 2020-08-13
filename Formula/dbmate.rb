class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.10.0.tar.gz"
  sha256 "bf00360c9eb12151c157cc227a21f6688d8ea89de571b618a018b081637297a3"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7dbcd31fc1d6603755048c81fbf05e93db43133ec436e86f6e29874179ec228f" => :catalina
    sha256 "1db09b97b07f8a8c8f3fa214c3dcfcde2e538b4a47c565606523ebf36f29d6a5" => :mojave
    sha256 "f3863f209c8853f24c64df469703107a22b3924daf73671d0a0862a198620170" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s", "-o", bin/"dbmate", "."
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:///test.sqlite3")
    system bin/"dbmate", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
