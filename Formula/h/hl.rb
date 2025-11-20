class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.32.2.tar.gz"
  sha256 "40a22a18af4d22cf416313050d93d9629446f22a52692b465f460eb30f386e1b"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08f653f4b3d9aa4c6b1942462699a618392931637b7620ebcac8e69649ac98ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de8dcfd3475f162985bdc542da2557bb8a52005d258c799dc1d8dd7e485ed5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12b6b258aeeced70db6dcaac204124d2ffdc3b214f21b9ceb1cba997cf8fbc22"
    sha256 cellar: :any_skip_relocation, sonoma:        "31e0be0579508e05b09a18e0f114fb145134775035d5795d657df44e9348dcb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04170a2b573cca919d29aa2ed2c94a16ac0182bc1f283ee106a3d96f0cee6361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b72a64100af2ae4619e5580bcfe8d49b7a497ed7740226467a42784931f9c58f"
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
