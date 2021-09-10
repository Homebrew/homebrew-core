class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-09-03T03-56-13Z",
      revision: "a19e3bc9d9dd08299229e49081780c79e6cf6a2b"
  version "20210903035613"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a95f4ad5cfe30d4b5c4657d7dae0295ee9cc08a9e6467458c69db47b6d1585a2"
    sha256 cellar: :any_skip_relocation, big_sur:       "442ad228c323b700746441e5d788592eb5289503bb6b9b3afa92d79c509876d1"
    sha256 cellar: :any_skip_relocation, catalina:      "915bfd9c56efc7ef4f3241604eac5f2e10989208e32fcecdc8bc7cb6884dd45e"
    sha256 cellar: :any_skip_relocation, mojave:        "6967ff6b48b46730c1e6159d0f7677a25bb17ed59294ea6e360d23430015eb17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb97bba2d59869b09f6f955eb6a2f57a00ea44b0b4be4a1a32b0332ee6579503"
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
