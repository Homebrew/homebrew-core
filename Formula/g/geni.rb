class Geni < Formula
  desc "Database CLI migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/beta-2.tar.gz"
  version "beta-2"
  sha256 "8d6300cd75461a98348695d0bdff6084941b3409c9b79031423272185bdbf6bf"
  license "MIT"

  depends_on "rust" => :build

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad7ad690664de5ede52468694a5e275f29ed4d036579a116c2fee4538978481c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad7ad690664de5ede52468694a5e275f29ed4d036579a116c2fee4538978481c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad7ad690664de5ede52468694a5e275f29ed4d036579a116c2fee4538978481c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad7ad690664de5ede52468694a5e275f29ed4d036579a116c2fee4538978481c"
    sha256 cellar: :any_skip_relocation, ventura:        "ad7ad690664de5ede52468694a5e275f29ed4d036579a116c2fee4538978481c"
    sha256 cellar: :any_skip_relocation, monterey:       "ad7ad690664de5ede52468694a5e275f29ed4d036579a116c2fee4538978481c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ac93af2d1f2713090db5144ffbbd2971f993e1235446ce9e42722b0a4bdacd9"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3://test.sqlite3")
    system bin/"geni", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
