class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-11-09T03-21-45Z",
      revision: "f4b55ea7a70f8a065fb7065797696e815241ff93"
  version "20211109032145"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c13205404309a87e93221eec9a7436d7a7292ce7a7f1f0a3a05b6a9a2e47aee3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ef744f010aab5f0eeb28f5a73abe093b0165681e5fc6e3e8ddb2b827c363650"
    sha256 cellar: :any_skip_relocation, monterey:       "3ef98a07a740ee45a59636e6b65e5e37888d5e59b4ff84d09c1f472018d721a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7567650d3ac3b166804fd32314dbad4f3d9ea274d9925fa2b27bcfe2c97b5290"
    sha256 cellar: :any_skip_relocation, catalina:       "b1ea36a141715bd4f4d7b63c31be1ba41c267daf47467fb076fcb3c74617bcd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3d943a04bc873e878429df47a25e440b75a9726adcee8853b9d200b5a2cc953"
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

      system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
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

    assert_match "minio gateway - start object storage gateway",
      shell_output("#{bin}/minio gateway 2>&1")
    assert_match "ERROR Unable to validate credentials",
      shell_output("#{bin}/minio gateway s3 2>&1", 1)
  end
end
