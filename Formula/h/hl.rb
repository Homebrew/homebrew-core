class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.35.2.tar.gz"
  sha256 "5794c81f71dc055fbcb67dc6a6fb1469f1e0631bd0974249fba6f7d885410ce2"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67dafc16a46148b3f6c91563dcbd754096fb35c6b5dd2751931ba236ad9922a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7fd7572d79e1adefb8fb82981fb0dc4c2636079711f92410016cc2c95cb343a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "673e9eef2fa9e6a671f11841a6f6c75fae3d17b40da9ad0cbf81ee720493c4c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d915f11e9007df18fa8f0b54fd6d5bf1e9744e91cffe0379c825934702517cc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca84b1c89e55f8b4cd6cd57fe3e4e60ea5ddb92f4abe47b04c50b4c2c09b0dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ce91e07bc2981946a5116b1780e4190fd896cea91f22f853063c0b23ca8abc9"
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
