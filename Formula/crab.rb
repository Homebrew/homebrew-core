class Crab < Formula
  desc "Web scraping and parsing toolkit"
  homepage "https://github.com/bazhenov/crab"
  url "https://github.com/bazhenov/crab/archive/refs/tags/0.1.0.tar.gz"
  sha256 "db1ea5303ee7b9ba95e2f1131340a2e552748ec47d031f74a4de725270f46110"
  license "MIT"
  head "https://github.com/bazhenov/crab.git", branch: "master"

  depends_on "rust" => :build
  depends_on "python@3.11"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/crab", "new", "workspace"
    assert_predicate testpath/"workspace/db.sqlite", :exist?
  end
end
