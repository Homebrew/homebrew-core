class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "a154627dde61531c0eb76cc427e253ed6da7cc3410ed4863c6413160e545b45b"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c96e94dcb0827dc670d37e453d6647a6675c988a651b7be268bb80a631d1637"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17e560cbc74b1ca1f546468c77c0b984259e0a9c96c0a90ea2b2089c713aba2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae6342232169888b1878fa9e28b8b905e8ca5897149e4d400ceedee963a2a5ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5a05db8634de57035484ed78159634e2bbd2af8493527d375dcfc3d88c30e97"
    sha256 cellar: :any_skip_relocation, ventura:       "85c6df4b6184f9a398b178970b5480b5a0b9fc42490fb4f0faa0714695eac15e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d63e7ed8ad71325f5e2834f6118861df495aa57bcf5fcc21530d5806e4194568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd394b957774173dc6746f30aec2783d69428b3f3adb073044b7bf2ffa162fa1"
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
