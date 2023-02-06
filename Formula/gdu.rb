class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.22.0.tar.gz"
  sha256 "cb655d2c609925fb137357704dcbebf7d80796d9011ed43df8c79c18cfa893d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1d4183f6c0d3d1b763872081c0a7cc162c802f039f9b807dae8d436e78f0632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f788c8a54d96df7479b9a7fa9c658e03ecfcc1f6c292686db5891c96fed1855a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ca84638942e9e0c9edaab6cfe26b2d28aea18b6f7b6a2117104127cd08c0f5a"
    sha256 cellar: :any_skip_relocation, ventura:        "0f4ac96b8cf458f99ec81ba6b3be50d7536732dee8513a649795246939ae4161"
    sha256 cellar: :any_skip_relocation, monterey:       "5364f0ccd56b5e70f7476e7b3fc3d32e6dbb273ef1fac9c9395f2fa8465c2c88"
    sha256 cellar: :any_skip_relocation, big_sur:        "134a274446e5a952c39be11ba1a183d85493ef60ded16b070c2b3b6db6918f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2411f3e1b20abf2cf46bf79447ca74822b2c85ee2c8039e1bec673a58a56f906"
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
