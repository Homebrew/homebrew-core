class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-10-10T16-53-30Z",
      revision: "ec0fee620843cf8f878d19a00d44c016cc2323ab"
  version "20211010165330"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8480f40b1fd3633d87caa0c9c974bd2e6d488cd9331814a9067d97057326eacf"
    sha256 cellar: :any_skip_relocation, big_sur:       "43f44201d2582135fb58efef430f039905ff1878ee3f884c96256cf38c765c3c"
    sha256 cellar: :any_skip_relocation, catalina:      "726f3ad5f6c6c18bfb7ddce7443fff946a7964391f4438305cee9b1ece95e6a8"
    sha256 cellar: :any_skip_relocation, mojave:        "73a57743d7c5506e0a7953fa5139dea8f2d0dc5d5f84525886721b516fbececb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1141d9b888e86364172fc20c2693c365b751d914dc8246e00c9bb7ef03325bf0"
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
