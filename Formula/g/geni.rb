class Geni < Formula
  desc "Database CLI migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v0.0.1.tar.gz"
  version "v0.0.1"
  sha256 "6ece9e572aaee2c0555b7c5e880fe7a63469397b871d6af8467d59ea868b5351"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"DATABASE_URL=sqlite3://test.sqlite3", "geni", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
