class Csvxx < Formula
  desc "Compile csv++ source code to a target spreadsheet format"
  homepage "https://github.com/patrickomatic/csv-plus-plus"
  url "https://github.com/patrickomatic/csv-plus-plus/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "9879085ea821071cc95c6411009dbdf4eb8c756a289102d04152ec70e7d2f2d9"
  license "MIT"
  head "https://github.com/patrickomatic/csv-plus-plus.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "csvpp" => "csv++"
  end

  test do
    (testpath/"test.csvpp").write("
foo := 1
---
=foo,bar,baz
")
    system "#{bin}/csvpp", "-o", "test.csv", "#{testpath}/test.csvpp"

    assert_predicate testpath/"test.csv", :exist?
  end
end
