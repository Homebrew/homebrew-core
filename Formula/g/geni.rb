class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "f1997ef7be666bd6cf40a3bfe631ecd01c3ce9d441120bbc623073e4a61292f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37f4005cc0cefbf898f96f8eed023850ccf54298fcba0393a6c0d920620e4ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39be2d763a87d9a78f62702f9cdb6174e9fc59d04a6104e89e16e159d1848a09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3708ee87e5cebb66aa5d1c3b43d3ceb26d8699fabe236fced5228b275af3cdb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "04ba8b7c186b70d0b1fb8b5d4a3518506e0f0bd20e1f3eda1a9bbd0f1aec3501"
    sha256 cellar: :any_skip_relocation, ventura:       "f779a384b9c287202b52d90a8598fb2ac2cd8b2c8553f344681b0a338db37603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b02203af60c022b420c758019ba1b132e3258e23404d073ed8a805bfb73a03e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3://test.sqlite"
    system bin/"geni", "create"
    assert_predicate testpath/"test.sqlite", :exist?, "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}/geni --version")
  end
end
