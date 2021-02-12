class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.5.0.tar.gz"
  sha256 "bcd96f457f4bc606fcbe4c90a5b71595158c75e6a9736b02902c669cd6ef382b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "58f1a4b29cd454176e2e7f20d55706185764fa5553eb19621773e01fe3cf6c03"
    sha256 cellar: :any_skip_relocation, big_sur:       "034c01847a0c8b707576190efc8dcbff72463eac7bc935504705afd08501092a"
    sha256 cellar: :any_skip_relocation, catalina:      "3393872d7b4ace817e82031cc3bd3d8e48cd15ab01bd79f946a1e0eec4b1873a"
    sha256 cellar: :any_skip_relocation, mojave:        "f095e9c558a1678b58932fd8d8a736babae306f2fc7fb1ea82a4b6587a6df42e"
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
    assert_match "4.0 KiB file1", shell_output("#{bin}/gdu --non-interactive --no-progress #{testpath}/test_dir 2>&1")
  end
end
