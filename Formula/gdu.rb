class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.1.0.tar.gz"
  sha256 "bf36852ead6db878c1e0e5b15e5b4d832c67107ec9915f783d0ea9fefa71cc7f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d745b43e0c5fbfdece69f1953d6b620d05f9dab9abedeedbbbcebd003f85a7c5" => :big_sur
    sha256 "3c6d950843f7f456d0edc5823fbc8af68a0150de2a303f3b74f92407771538d4" => :arm64_big_sur
    sha256 "6c07b20818630a07299dbb35d15d53414bb6b38f8f751cca7332017c41abc31a" => :catalina
    sha256 "f6dd80306d31034f8380967cf00d9e18f1fc183c7255d15dc1f7ade71bf0839b" => :mojave
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
