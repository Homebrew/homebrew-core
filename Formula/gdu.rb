class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.4.0.tar.gz"
  sha256 "2f5ecb8a39e21f5c3a29408a33f8dc2014f95e756e8a199edb852163591f3227"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca4d1dfe1fda5a72950355dcb6588d18019be10bdb121779bd238b91eae2bf6e"
    sha256 cellar: :any_skip_relocation, big_sur:       "b8916bc2d3247334a465277c7a0ff6b73475f20dcfe9e009a2609cd9b3877c08"
    sha256 cellar: :any_skip_relocation, catalina:      "71974bceb4046f60f3742d984dd8fddd6b731357b46e2b66d4e807176f61c6bc"
    sha256 cellar: :any_skip_relocation, mojave:        "9cc16ee324944e1b2e49124c4359a52b686798916b0ecd6e3b1b883b230013fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db6d468f545ebd775e5f87cd41d752bea2e98a38624e5dd1cfe6be03dedc141"
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
    ].join(" ")

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
