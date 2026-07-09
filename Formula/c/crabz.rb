class Crabz < Formula
  desc "Like pigz, but in Rust"
  homepage "https://github.com/sstadick/crabz"
  url "https://github.com/sstadick/crabz/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "2bbd8eb669a6570b104a0eb412d2492d5a9296524964cd676440069d27f52e6c"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/crabz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "184c885b4adbe8d9fae4388cea1347debaa6e62a0c9c5726e1b6623a5062c1f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a63f077a041350830a61b22d164dc5f00dba1db420d109d28de740fd9ab3b5c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14ea54436bae9bf5efd138c72b306a6d112576b01db726e4137966b7b253ad27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5750118d971ca993668011b90381d97b09d2a739212f1ccdf931cc28a5dd38f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7ae6a787a7a1797943ebbf743f8d5e833b18241fe6e85c678dfca850040059d"
    sha256 cellar: :any_skip_relocation, sonoma:         "577d2a7fbd81e94e01cea85c3b3da2c759a88146189c66d5a61f9b32f6d9ad10"
    sha256 cellar: :any_skip_relocation, ventura:        "bf7734ca7c9ba5fbf35a9ee9689d24545e069ddcc7cea47305d3db9be1bfbfbc"
    sha256 cellar: :any_skip_relocation, monterey:       "b6af3a466b9ed8b122cc9ec0b8e80bf0c8e60c0ff0ec32d5976bc6bbacb04fdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "36844bc642d323b46061d065ce3f0ef54fb344950a711ace63ce737ab8c91272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5843ff105bb50beb4e6712e6479edb8e3be80d5f1508e10fb7743d19ca9a6277"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_data = "a" * 1000
    (testpath/"example").write test_data
    system bin/"crabz", "-f", "gzip", testpath/"example", "-o", testpath/"example.gz"
    assert_path_exists testpath/"example.gz"
    system bin/"crabz", "-d", testpath/"example.gz", "-o", testpath/"example2"
    assert_equal test_data, (testpath/"example2").read

    assert_match "crabz cargo:#{version}", shell_output("#{bin}/crabz --version")
  end
end
