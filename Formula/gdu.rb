class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.2.0.tar.gz"
  sha256 "839d6f84ed656e07427f209941202ed53c02825c8de64c6f838168a65b0b2e3c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "114bd9f9c0776db9b952716ebdc35bae2c07655b7a10df6d6a3b1eb177c9a304" => :big_sur
    sha256 "5cf0acba4917e430cbb628986b2d251c5e7908a535d2f44f8782fb8ffb5e99af" => :arm64_big_sur
    sha256 "3b7da285b204c76c1f13de3eff378df0dec2f446204e24fc94d0fa75bd1ee463" => :catalina
    sha256 "b5f87dd98221f7f91de8f4fc737d51a1f7515bf7f7a48519c2b54566013cbadd" => :mojave
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    time = Time.new
    user = Utils.safe_popen_read("id", "-u", "-n")

    ldflags = %W[
      -s -w
      -X 'github.com/dundee/gdu/build.Version=v#{version}'
      -X 'github.com/dundee/gdu/build.Time=#{time}'
      -X 'github.com/dundee/gdu/build.User=#{user}'
    ]

    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir"/"file1").write "hello"
    (testpath/"test_dir"/"file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu -v")
    assert_match "colorized", shell_output("#{bin}/gdu --help 2>&1")
    assert_match "5 B file1", shell_output("#{bin}/gdu --non-interactive --no-progress #{testpath}/test_dir 2>&1")
  end
end
