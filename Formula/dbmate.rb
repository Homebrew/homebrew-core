class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v2.1.0.tar.gz"
  sha256 "c48939c345812a9b87d6f97422277c0bcbb8d84aa10612efab7f964e68dd6310"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17f73b8e03656318ac66c7657fc0612503bd0299308ce0ce5899be163fa9bf57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b289ebbc3edcdd7771117474bcf96fd5569fd71e9e2d894ae0da7df79f1a324e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6417182b480a16939560294e9bd6b52b574278348682a592c8cbe2cb4cd8922e"
    sha256 cellar: :any_skip_relocation, ventura:        "5e68ea847dabdbda4e553c431d4d5fa387ffa502ed44d5a2c7f8892cd93f2772"
    sha256 cellar: :any_skip_relocation, monterey:       "1141db907f91a7d53cd868d7c0359544fc33f7a2a21cf375f585b66203127083"
    sha256 cellar: :any_skip_relocation, big_sur:        "46df1df7a4ae8a7509edc13a1620097a961dd96ff9d76619c80571f123eb8ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "153c0e747fa68410bff9a77b904892b0ecc8be2e267430a2a8c61d1f54941e5c"
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
