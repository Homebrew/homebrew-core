class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v2.5.0.tar.gz"
  sha256 "3413eb07bc67c56c04355d0c2bcef65cd73a29e1998243c5166b3cbfe9269d60"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46bb36c39d4895c6b2102c59afa52df82b9b611dd29c3cfeb1023f94eeed5c81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db730cb7add649e0ffae95aee1967a8cf8fa5e7e638acf2ea62828bc1e932f95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cef527308ad99f57f74062846841bd2e648e246fad287e306aa93208dfa3f482"
    sha256 cellar: :any_skip_relocation, ventura:        "cad824f21e8848833a93222ff0a2a3d75385dbd623f4dce1964417e90082c3e9"
    sha256 cellar: :any_skip_relocation, monterey:       "428861d86b4bd6e82553cdc4ed9151d65a229c9ad832f9b362a5fdc7c894f4d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "14d58d273b304d29b0a5b4b4720ee96243f879162ec7ecb9de24c8c0eea0e395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4be4d8e1ddddcd36d43c239c07dc651ce26c00784e52c56de10a254148a87f6d"
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
