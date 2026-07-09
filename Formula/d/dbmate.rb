class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "e7b57143c9ee436e9373e19420e752fef7a0b03807fe381bf7d039c7b9d2f6d6"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3bff0524ec4aa7175c2733c112a0916c07a9b3d8b3739a3850207a9a2bc03f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c362807df33805f8d475e299bc6a22c9a1dac8346e445ffe1eee638f4f3cd8c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b564a1bd09368a6c2323d2803e7eb77e4479f6df282e5255f4afafa9fd52727"
    sha256 cellar: :any_skip_relocation, sonoma:        "82ee30716276545ce62eb907c023e603867ecdf84e2063cdea201753cd869aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9789c110b212bd6d1166331503055f4582c2dde56623dc00a5006dd2153af5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13c5f4c9e787578f8ef9fbe8cfc1c970537e7c00b8c94af2bda4dfd1202890a2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    tags = %w[
      sqlite_omit_load_extension sqlite_json sqlite_fts5
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:)
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_path_exists testpath/"test.sqlite3", "failed to create test.sqlite3"
  end
end
