class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.17.1.tar.gz"
  sha256 "1b37383e0054e059b02f71b3b5f216c19044f64432b5c5e59d62b361c12c9ad3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ab1003eaef381be25417c1f6187717ef95ac6106e1b1797f3630b77e04a1be5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32c55e7d3db7e2b909a61711d8d3549a8a84b594cf219b2f806ba3ccfb14ad74"
    sha256 cellar: :any_skip_relocation, monterey:       "175aa6cfc4c79dfcf0a4e572421e986681564373dcdd70e8ab62840107484bef"
    sha256 cellar: :any_skip_relocation, big_sur:        "135ecfeca40a6d7dc027f8138420b298b00da116280bfe4527496f701970143c"
    sha256 cellar: :any_skip_relocation, catalina:       "230c90992f550343307fd61986f110861a7a0902609ffc062714755e07165d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dae1175f102cf298d2a7f14eb81789df869da2bcb9ce5eb2ca83056594c3a94d"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gdu"
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir"/"file1").write "hello"
    (testpath/"test_dir"/"file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu -v")
    assert_match "colorized", shell_output("#{bin}/gdu --help 2>&1")
    assert_match "4.0 KiB file1", shell_output("#{bin}/gdu --non-interactive --no-progress #{testpath}/test_dir 2>&1")
  end
end
