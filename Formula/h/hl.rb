class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "533a33033fc15a65a3952c77466f25943a52744334dda8749e15168580f355e7"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "368470b373ed3e94d1c0399da6e734d77fee38f3003889ec70067e22bf8dea18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67b3b61531ea1ff7785f5b8906f2f48ece5c8dc2f64d75046fc4ecafb13ae326"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea3c2c6574a0af1e992d43d86a1d7509a9d2f2b5ff0fd508abce4163acf9c027"
    sha256 cellar: :any_skip_relocation, sonoma:        "c24b898374873ac90daf92d03ea1a2d7cf3960f82a7350e1b307cc82d64a9186"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3713e3f60bdacb31ed3fb0e78c3b26d7169fe5a82db9b72f075e8d039cdaa53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e5d6ca53dfa346c6a91721790589fd4b7b0c4b345f70eaefb6bb6288b3ad46e"
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
      time="2026-02-28 12:00:00" level=INFO msg="Starting process"
      time="2026-02-28 12:01:00" level=ERROR msg="An error occurred"
      time="2026-02-28 12:02:00" level=INFO msg="Process completed"
    EOS

    output = shell_output("#{bin}/hl --level ERROR sample.log")
    assert_equal "2026-02-28 12:01:00.000 [ERR] An error occurred", output.chomp
  end
end
