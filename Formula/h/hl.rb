class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "f11093953e34edcb8c0a93e6a19660f78c4b6fb4aa60f9120df83e83099f4a93"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7323bd3959dd760479a64956e4d069a3a670e64db07f0176967b02c9ae5330a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac71d65fd65d765baf16db56fdc8b7a8ee25aa07f1967b8729d4c3478079fc9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57239c94d359ba52337b07cf8352f9ebb0acac88785b62c4040dc0e58c541a35"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a382e5b1964529ccc068375771bceb573b63661f9409e01f1655cac0082f327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2487d763d1ca13db63e469ba2071be265d948b843e99bd051294901163e5ebd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a56b7685d0533e901f4f6c091743ff6774dce2f8554cbf2d44eafff8f76bc6"
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
