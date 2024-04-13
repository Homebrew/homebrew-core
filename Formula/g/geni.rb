class Geni < Formula
  desc "Database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "0d81ae5ef89477bdee18c0e74d3490ed06bf594ad4116a66e96d38fab46cbe41"
  license "MIT"
  head "https://github.com/emilpriver/geni.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3://test.sqlite3"
    system bin/"geni", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
