class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "f62d5bd271653f4ce46736648b03b8e68b55c552afe667a4c8a52c1b8a3b85ca"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v((?:0|[1-9]\d*)(?:\.(?:0|[1-9]\d*)){2})$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "320e12bf8979beb2e174f4d79dc4e37919f0b9e551e1cf32a9785e8c78dd1920"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c314af89417d4ded8184e3e880e5ff7570c2447852d3a8225a08760e0f8b894"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1a53bdcd74f3fc77754fa9c3ed58baf48a940ab7e5cb4a36b342431b8be833b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d83f355a2ae2ecfe67a68bc51f426991152a52f610729b61068e3b43a9ab4409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "868a4c32935ddb99da379d1659cc51f4db0f8a6b8aec91271af24b416d88fccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41e9b5dcaa9e7f60dfea74be1599d0b0fba23169a1bdc2e2d12bad1294b628dd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hl", "--shell-completions")
    (man1/"hl.1").write Utils.safe_popen_read(bin/"hl", "--man-page")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hl --version")

    (testpath/"sample.log").write <<~EOS
      time="2025-02-17 12:00:00" level=INFO msg="Starting process"
      time="2025-02-17 12:01:00" level=ERROR msg="An error occurred"
      time="2025-02-17 12:02:00" level=INFO msg="Process completed"
    EOS

    output = shell_output("#{bin}/hl --level ERROR sample.log")
    assert_equal "Feb 17 12:01:00.000 [ERR] An error occurred", output.chomp
  end
end
