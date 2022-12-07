class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-12-07T00-56-37Z",
      revision: "04ae9058ed5b135c27a3662b1153e129e5cf1483"
  version "20221207005637"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb3aa445dd9c78cc59974926c8ca9233acef8c02d4a29ebd4163c186528f75dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b71fc0a17c9dd324033e7e1f27257f50f3bb7237c6d4955ffd3eedfd23e249c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee26048f03ad21f3e64d1755113a3b09b0e549f70147bd43c491c55d1a6326f9"
    sha256 cellar: :any_skip_relocation, ventura:        "1587bf66cfd4ba4db1d99b555c35159064bbf81c99b29f56d968164e8ba13a52"
    sha256 cellar: :any_skip_relocation, monterey:       "ec7086adc8d4e658f1bfd6aa21ff50021439f9db18a717232eb79a88f86864d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "56c3b883004cc73792287f5968a346277bf773183932df916e2b1f297b7d98cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9df437194e17702a072b83d511344e410de2e2f0a892e945b87f588878abd552"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end
