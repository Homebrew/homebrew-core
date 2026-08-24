class Crabz < Formula
  desc "Like pigz, but in Rust"
  homepage "https://github.com/sstadick/crabz"
  url "https://github.com/sstadick/crabz/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "fb7833a83db958c8abc3b688a8905385cd19e721133ed0aa1d1dd290ef65d8f0"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/crabz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a77bd30e73d8f12c1b496023c63ff4fb2bec06d4e7e4318115446ea48de5c9bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9a4a7963fbb54987363665afd1d43b254a5745629637dcec5fd822221e9e70c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eba5da5c085d520b409b5ef4a367d05809772534f33e2471fb19565b763da104"
    sha256 cellar: :any_skip_relocation, sonoma:        "81bc9ff6313da8ed52c653b8c5dd50b32a82db22b5c844d89b2fa975fd113539"
    sha256 cellar: :any,                 arm64_linux:   "fbe2d80b14af454b5f9bfc6a2e3ea8880b5525f125f4eaab4d4245e53974fe4c"
    sha256 cellar: :any,                 x86_64_linux:  "17f76a2fa38bd96fd1cb79f113d51759edad95abe9173f67e857d74e5463d52f"
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
