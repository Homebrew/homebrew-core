class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.13.2.tar.gz"
  sha256 "f4f237f6da470599f6393591282cfd67922a963325859a939ca40ba7e18024a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d611527932bac14d4f6c264f33671da1c3d67e82d8b85cd47980a7e525ef602"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe36ad8a52809c1e7463c91f0a63b4e38fc5b0df6ed26c34aa2a2ee08adceb41"
    sha256 cellar: :any_skip_relocation, monterey:       "7011e39ebf8bb1ec3928728ceaf6a386e85cd88ec0268720e901d54e212c2247"
    sha256 cellar: :any_skip_relocation, big_sur:        "257830fc62f9ba89a8e6051516a91694fea8e39bf29a2e73e74427cbcdf54ffa"
    sha256 cellar: :any_skip_relocation, catalina:       "e9e4659009939d0c8fdbf0a983043032775e2bc909b89a0c3597c04d17d6e8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac1074080afc1fd820948ce222b3fc6ff3bbb20e232b9f6a5ad19165487d43a6"
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
