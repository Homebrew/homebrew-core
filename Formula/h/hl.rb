class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.35.3.tar.gz"
  sha256 "f6801a62c7f77012b66cb8a7e21737319d1d9b16e19ff793de96dcc02509b73b"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "237f1430655f865d2af162a0b7d5f56854adb82054691b9cfa8608391a8b39f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b6b55803d8b93370eacb3e781728ca6147bc84ae7cdb8acf95a9759a31e49d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f2976339fd1f254cd34e8d983b1bf332f56c2f62df9c281079d312f7259bfbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b93415f05e85c7c0a06548a0370a3a940365647454a65f2528f5b3ad0c1d71c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02bacfa0d7086e8bb939b724b82a7809ec519f3a1e0c55fd67e36863c1b7c605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81786c37ef77fbec1523438786791b982d7a7a041be7199e7c79a28cab3d69c4"
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
