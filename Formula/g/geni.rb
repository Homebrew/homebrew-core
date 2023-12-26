class Geni < Formula
  desc "Database CLI migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni"
  version "0.0.1"
  sha256 "7ec2e4db1a14cbdca6fff26599714eadf2b593c29e492cdb51283a828b449e38"
  license "MIT"

  depends_on "rust" => :build

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "TBA"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"geni", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
