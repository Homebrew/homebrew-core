class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.36.3.tar.gz"
  sha256 "941780a2830f236037b9732c272e1ce2127a05191f257ce11e47b7a483414f3a"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d206ff6a7d0fc54233ff8b2591778fc27994dc8e4e6b55926d6724031f21d87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2bbd782bd830e4c358cf3db5a977bbfcb17b8455a9848f8cbaa939b157f5e92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "259c6bc536b8424f42992f7aefa2134b4885d60f036973d2ff66d30f69992c72"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8ae8f7d0fec73c94aea2d2dc693d282428a968046492a6bee71de24d6ba1a4f"
    sha256 cellar: :any,                 arm64_linux:   "0e5c9cedf3d9451103990fc4873654fe75fee9319af9e3bb9a8ae629a6385752"
    sha256 cellar: :any,                 x86_64_linux:  "8b54b4ba3bc60f9a356e5f60ec88e2b6dcb32d11124c71540ce7fe234aba95d2"
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
