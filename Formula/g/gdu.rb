class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.33.0.tar.gz"
  sha256 "14419fa66046c9fc2d1a6deae0c784c4ac5561ba97e1bd39d622293530ed2788"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62b94b723d36e74098eb38ba7ebfbee001ec0f205d4d1e5e7b70b2e54343e06c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62b94b723d36e74098eb38ba7ebfbee001ec0f205d4d1e5e7b70b2e54343e06c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62b94b723d36e74098eb38ba7ebfbee001ec0f205d4d1e5e7b70b2e54343e06c"
    sha256 cellar: :any_skip_relocation, sonoma:        "623633b3faad64f9092f20d291ad9ebb89fffab4bca31239f3d0856709420b09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c925c87e46ea2303555fa6127b0f7f2d1b578af492fa34113afd4d0da73426d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61b021cdf49526d98f36a330f7610a84fbc2cb16b12267b785939192790cce8a"
  end

  depends_on "go" => :build

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"gdu-go"), "./cmd/gdu"
  end

  def caveats
    <<~EOS
      To avoid a conflict with `coreutils`, `gdu` has been installed as `gdu-go`.
    EOS
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir/file1").write "hello"
    (testpath/"test_dir/file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu-go -v")
    assert_match "colorized", shell_output("#{bin}/gdu-go --help 2>&1")
    output = shell_output("#{bin}/gdu-go --non-interactive --no-progress #{testpath}/test_dir 2>&1")
    assert_match "4.0 KiB file1", output
  end
end
