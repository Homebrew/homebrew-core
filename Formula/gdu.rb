class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.3.0.tar.gz"
  sha256 "8e785a4fc443db17d4ba484a4bddf79208baf8841f9b6b6f1d50981a443f0b66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6454cd9a67a41e7727b42c65239cbd6487c37f112d27d64a070d8a694c6b484c"
    sha256 cellar: :any_skip_relocation, big_sur:       "bbf40c5f5548254dbf7f587aad1064f972d825d60974a110a1aed3b3d8298bb2"
    sha256 cellar: :any_skip_relocation, catalina:      "70d68fbc9db975bdfc55850696ede78c0a2b5e1ccc9b7f5c26f159a8314555da"
    sha256 cellar: :any_skip_relocation, mojave:        "b9b1dc246a68194e5e8f4c718632e716d633ab913c26bb022219053078a79bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76dc34189b6999061b3c584530c5f69d66ffca018c8be08068d6d60cf7f6e905"
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
