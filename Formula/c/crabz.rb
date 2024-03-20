class Crabz < Formula
  desc "Like pigz, but in Rust"
  homepage "https://github.com/sstadick/crabz"
  url "https://github.com/sstadick/crabz/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "2bbd8eb669a6570b104a0eb412d2492d5a9296524964cd676440069d27f52e6c"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/crabz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af699a0228f047d0544b3095764bef4dc5ccc0336c13ff3bc306f27b679f7989"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f61c359fb0a0041f92fe056b45ccf73d9f02bf0fd9976601459d2264428755f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffb214bd38d27a22ec0361a465c3a56279c9bbe0f8b1227fbc9482c20e8d0398"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fab9b0230fdb0ff9dff9b1f4bc97f1b02c84fda834155e5df7f16917b141a71"
    sha256 cellar: :any_skip_relocation, ventura:        "cb25eab893baf38b6deb477928f313763202c89cd8fe7982e098708d557b3cab"
    sha256 cellar: :any_skip_relocation, monterey:       "fbb9520455e96fcb6eb32191be9ba97c040c6113a49ddde700881d3ef6190608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60095aa977ab3b03c47ec8de50190199510cdc9eee314104c0b3ae494bc9de9f"
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
    assert_predicate testpath/"example.gz", :exist?
    system bin/"crabz", "-d", testpath/"example.gz", "-o", testpath/"example2"
    assert_equal test_data, (testpath/"example2").read

    assert_match "crabz cargo:#{version}", shell_output("#{bin}/crabz --version")
  end
end
