class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-07-30T05-21-40Z",
      revision: "e6eab2091f632622fadbe3b25bb4732125b2d5df"
  version "20220730052140"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49213f9c17755743ad1cc052f7a8b0758d2f8ccdffb95a7fb813c7499cdd17e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a3cab0d66bfc38872fd8fecac6797313a32c5c8e793186fc1736829d4fc9f93"
    sha256 cellar: :any_skip_relocation, monterey:       "1f1b1050ea10bf11eba839bcb5446e6b7725139ef4c8cfc1882ba011dcccb842"
    sha256 cellar: :any_skip_relocation, big_sur:        "e44c9abe544bb913986e5e065c48326b158a8e2709b1c9374c8cea2bed33c1c0"
    sha256 cellar: :any_skip_relocation, catalina:       "41ecda2fda7dd74143a4832c4c7e1aae4bb377d04845f9f51ae718d336d5c8a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e831b71337093c552703d5c556c1510ae8c5175526fea9f8babc317fb2958a4f"
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

    assert_match "minio gateway - start object storage gateway",
      shell_output("#{bin}/minio gateway 2>&1")
    assert_match "ERROR Unable to validate credentials",
      shell_output("#{bin}/minio gateway s3 2>&1", 1)
  end
end
