class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.36.4.tar.gz"
  sha256 "ff4420d0529f490e4e953c037f62ef05b73b9d900a7a5492049f32f0b90b648e"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d796a0df1ff8dbc8dd93db584c196b6e37433aa230848ce51e3e114a4693150"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "71cf9fba5197ace28d27bb3f7adea55f53d2362589323b8d66211fefedc4dba5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ac29c584f18bb6ca9371e35aaa83a5fe450b72ae854f0d0d0addd690c4b49ac"
    sha256 cellar: :any,                 arm64_linux:       "1f1c0635418a3bc7843ba47091cd50bcef64961a6c883d42f26043da438ac5c0"
    sha256 cellar: :any,                 x86_64_linux:      "3908316e2828e5ba791529fa769aa752b68185cace2e428bd927b4f9a74f6c72"
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
