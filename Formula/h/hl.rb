class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.36.5.tar.gz"
  sha256 "a40337288a0c113326ed739930166fdf9202d40f4f40583f05a5a27c1c043d3d"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42c97646c22584c4b4b9df01dc2ebf89f14663b19b7821f60095271824bbb50d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d34d6c5e2ade39fa93dfc5c969f94d7f053b48c8756d7c7b79f85b362d06e81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62218be7c51556ce2f2b761686e02ce03969c3f471521e906deae4ce5618a364"
    sha256 cellar: :any,                 arm64_linux:       "00bf85a442ad97605a371efc1b1d73b4de848c80539f22333c4a8a0ebdf92c62"
    sha256 cellar: :any,                 x86_64_linux:      "4724574d3234dbf3c77ff1323a9fcbe8b84213f03651a01dda070a2b869832bf"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
