class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.19.0.tar.gz"
  sha256 "69c47eaedd0fc1e664d5a08c91e7b107961145aa307d1fd11cf208dfec573f0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af1a10a0683a4dc9f04e4486117dca4dc0e056a8f2f7e11d76b3c4ba3d8b1eda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9c8b3f6d2bb59de6bad0a9b3544230b702b209fe75742728652ff11c6763dfd"
    sha256 cellar: :any_skip_relocation, monterey:       "1403b4f41c8791a56ecb72e1e8912177275e4e01bf21aef7311db74ca90100e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "83ef9d990b6122cb3041333e4baef535f8d0ab3747abbb69490d1d01bab3da53"
    sha256 cellar: :any_skip_relocation, catalina:       "54a54eba4e4450d04ef8447de47646b1154656b0eadf76a205bf9e71f55ae914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b09cc6e5ef3f43302cf35571de647ceeef368c3755a103c24206ee3f73f70f8"
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
