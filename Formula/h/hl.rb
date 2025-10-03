class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "6d216a13230f52c483997c02eb533eea7b3d2f5f9c8388adf09dd90e467cb679"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58814d7683a8b1a720d539dc4bcbd25c3c8aa3d60bfb86914a1161afcb6d726a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72c24fcf5220953e7d1d5bd0754fb15c1e3280231df7dcb595f86f967873a89a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "973de9eecfcf1b3d75dd935b3de35712d5559152d8decd5ec497328bedf19241"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7158a5bc21187b96b87e8bab733c4f0d76eeb105705c0b431072933901f2f71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d2ba30f5da84ccdd5efe010c25ec7d0014fb028cf8c20ee6c0cb760c365db93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "025c431e80ab3b8bab78f8841fe1e46db13b8bd99ea0d0ca984057049da1d0c0"
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
