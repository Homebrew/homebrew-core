class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.36.1.tar.gz"
  sha256 "dd31ea9afd848edf734143aabd5fdf66236ce2c866dc09f9dededb61d39fe63c"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "423c661dc89fa77e52901d6684f851ae0935f3a6d98805e52eba47608f758775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "423c661dc89fa77e52901d6684f851ae0935f3a6d98805e52eba47608f758775"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "423c661dc89fa77e52901d6684f851ae0935f3a6d98805e52eba47608f758775"
    sha256 cellar: :any_skip_relocation, sonoma:        "b64522ba91afde648b7480c06ab1cb2b21567d71caef8c0dd77a53ca9454aa20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35c4528f10ec56d64c6213d9870ad3b786961ef57ff4b87c81b6207b8e134042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a89b5a53737c2b86fcdda423d4469b73b02f4a034b90bb3661db5dfe49654fbc"
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
    man1.install "gdu.1" => "gdu-go.1"
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
