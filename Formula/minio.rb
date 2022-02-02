class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-02-01T18-00-14Z",
      revision: "067d21d0f23254ea9ced107ef1a408fed83964a5"
  version "20220201180014"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd5802f354f826dccd6cb0e12ba50fed7f95c3cfbc9aa55675886a0be93a5cbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a985a0dd7403154aec604ad0835dec7365ba0dfc8aa9c10285361d0ce3ff6494"
    sha256 cellar: :any_skip_relocation, monterey:       "9c0a065eeede4252abaffdec233f310ed3d3da170d6ea4f6aff300c8a259133d"
    sha256 cellar: :any_skip_relocation, big_sur:        "38bc4d9c1b282d15d57c4627235793ff9e7a83e716589cb82635832d8de30439"
    sha256 cellar: :any_skip_relocation, catalina:       "b9918ed627d55295124d8ffe9a4a5d61b5f0a95eabf41f8a65716d9279f206db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6a6b757eb86276ca6311cd74bf1b3cec4734535b06a5deafae8809c65815b60"
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
