class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.11.1.tar.gz"
  sha256 "e5a7069bd147949392b1fb536a8b34fa527da5b3505ace8f56d6c890a9f34983"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3aed26e4eabe714fcc132924edda355dde4acfea3ebacbbe4dca22ebf35d1940"
    sha256 cellar: :any_skip_relocation, big_sur:       "f2e56e3b919bd73c164b78e62b4840f2e9c6e2c5decd8b139a5c0a20194c82d2"
    sha256 cellar: :any_skip_relocation, catalina:      "800500e372463af790062b6cc842cde38b9489ee876bbe10be5cd26fbdad25fd"
    sha256 cellar: :any_skip_relocation, mojave:        "cab2d8826418221c1f14e797c5dbf2c9d5d3cfafc2255809f7752d928f06bfa9"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    time = Time.new
    user = Utils.safe_popen_read("id", "-u", "-n")

    ldflags = %W[
      -s -w
      -X 'github.com/dundee/gdu/v4/build.Version=v#{version}'
      -X 'github.com/dundee/gdu/v4/build.Time=#{time}'
      -X 'github.com/dundee/gdu/v4/build.User=#{user}'
    ]

    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
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
