class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.5.0.tar.gz"
  sha256 "7aabe063f6f0faa51a8427d37585464afba19b528dbf99f336ab114d20a262e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f6f9721087b52bd38a17ddc8de5b40e8879970f0ed9cbb2e706c1eb4b04fc1e1"
    sha256 cellar: :any_skip_relocation, big_sur:       "b78d3d4fe33cd177909e34b583bc9ab0f6390917a148738a49c6e230f7adfdfd"
    sha256 cellar: :any_skip_relocation, catalina:      "1d1b0bad384658eff44fc7b6da27f8cc6c229a0f3f5e21223592f71fc60c1fcb"
    sha256 cellar: :any_skip_relocation, mojave:        "f00f1e26775fd74b9c71fdb5c9161a5b0401cbbf5b02b447253f18793e0b2b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cc5bd91dd34de3c92d1ede83d5309dd4e05d06712951dec46d311cffe29f6a9"
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
