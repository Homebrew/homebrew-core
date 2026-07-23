class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.34.1.tar.gz"
  sha256 "e55ca18250d00f281e69a8663b65f36a80d0fa6ae04bad3fc9ec89a8fd57bf5a"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc8491c69ab661fa58ae25d24896b4e644dec90e9ed99b3abaa7ce257d293586"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7168cc7daa86fef4a695029734d8824884db776a3d908782ebcecfd74f9c41e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70b5e5cfd2e8031b87774aa478a7612abbab1f8d3bcbd14b704c6b51ec0e67c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "141eb5fccb49dce176d266761aaa0e57de2df8e49271d731130638f310b4d1c7"
    sha256 cellar: :any,                 arm64_linux:   "3f2145162cf8160911de06a612eb0fedacf02899a5389df9efdcc455f892d6de"
    sha256 cellar: :any,                 x86_64_linux:  "c2c5e7509ea71f75651c71500a20a6aa8086bd78eb8089926bd3ac35ba50df8f"
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
