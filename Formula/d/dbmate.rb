class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.29.3.tar.gz"
  sha256 "661daeac607260171f6d9fb25cfbd892d31314871bfb8983c544cc29a7c7d97c"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "985e741c1ce809ea550a73502358562b8d5e748ea7649465910f21d158590f2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22db913656a2e8d529b2cb7a6f899acd6dee6b768a5e5c4eda5efc3d761e8e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8842e33296b55086134baaff9bf39a059db845595239ebd23d717aee190c01f"
    sha256 cellar: :any_skip_relocation, sonoma:        "be09a80dc11c42fe22d34bd1caa198afd61601138afd4ac45cebd38075e5f8a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "553b15af4048be972df0b7b3f1f1d001b30048c575fb40208d100de79b368ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04600f1e184eb08fd7c47004c56d648741c6a87edada7f97b15a5bde11fbe2e2"
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
