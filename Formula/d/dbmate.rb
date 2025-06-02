class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "d45c3706b46e3a34f229329258eed09724ddb20da685eb3d62565b9c5fa0be3d"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c072c757e73fcb6407671cce10cad20dc8c9c936e2705d260a0885b35f0f3411"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc88071e93cd4dd7a7b4f07424e03b0b8b368f82afbb9cb3f4a1286241577e7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18c2df5545216821ece971f39558a2d2ba05b87b02ce48ba909a82d2a8e4fcc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3472015348afb4585a7541c299901792adf5f5c10ae18e50d660539261e1be31"
    sha256 cellar: :any_skip_relocation, ventura:       "e117fd0a6404774a1a9b432d054466db74226d5fe53e1669ca040f1c0163984d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d470c2496872f75b74a19909a632b5a004505dcc3e35673e1ac7b31d4cf26240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef8f6bb9684382a30b23a8e851b88fd28e614d425ad3b682b49d5a0225590388"
  end

  depends_on "go" => :build

  def install
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
