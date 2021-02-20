class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.6.3.tar.gz"
  sha256 "dbc4564394ba76f08525fcea8b71d69cf26868efb0ac6d55fdbe43f0b16617af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b242d6dffaaea190fee035d1e98d019af4292bd61ff388529ffc70ea1deb2a2"
    sha256 cellar: :any_skip_relocation, big_sur:       "09bf5691bf41bfa7db9ae293d0ece142d8abf0eab56755e7824e3d962a2ed24c"
    sha256 cellar: :any_skip_relocation, catalina:      "616c0ebd8c63923dfc376011a0b43e7b7b5ecb9a3b16a85393861eeba9f91728"
    sha256 cellar: :any_skip_relocation, mojave:        "c5c54c8d562ede2911908f9f1abd891a7f0f288e141ad6804a6ba28ad53a5c98"
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
