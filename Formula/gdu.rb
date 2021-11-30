class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.11.0.tar.gz"
  sha256 "bf47786642cae3359d918758f4527a10a80e01805566bec607bc8c2d8f35d4c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b3489b347f32396566560afdd49d40f03d7b77ead9963e24b90a576567cf68a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a39eb94c4b2d34b62f9dd30da38c6a3ff52ba8a7d4c8b514470f74d74fe8583"
    sha256 cellar: :any_skip_relocation, monterey:       "8313094536db1ee649317c2c6cf46c7eca19b4adb24993111404aaecca270c18"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c97a2f7c457f70e768b02bfceedd36ef56f3dbd049b85d7587cbcfcb5681afe"
    sha256 cellar: :any_skip_relocation, catalina:       "e64e7927e101efad03d0987f795edc0c9160ae753f59faeca95f5f01c2128341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f637eaa92eb3886715c63f6230947555bc4cb156296440df1b863410ac7d2c6"
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
