class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "9adf7e31a194c2527a810a3c25a010461c2a0ca55823fc79cca6b4f2a707b2a1"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2da0c3071273b57c20ee99f20b2489dc81798a2406e0a2cc8dda771ac785a79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba4f9d61a2315d447dd8e09935e978d0cbac3a16f9c00adf6ef3e31da5d17b77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "effc03a95fa897b83c81748a29d825db3cedb471d2e8713746ddb3ebe02cc8d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "22aa0447ef492fa8f2222aeb0cf63e800de7d3d2be44074d409bdd3d453635f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ea602d85a27ca2d6a17c119310638da3ee53143aadbc354b25fa00070ebfcdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a53c031314d9d2626ce2492ca0a1d00e1f476b6c4b51cdc11488b50e9fd835ca"
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
