class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-07-17T15-43-14Z",
      revision: "b6eb8dff649b0f46c12d24e89aa11254fb0132fa"
  version "20220717154314"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4aa22e11f6d49d05453cb1b45ca032ada0506b8a1fa0084a67a148d88041953"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff797a3b729c3808c80de8ea3070cc1217c207a7d0093aa63516e726b75dbcfe"
    sha256 cellar: :any_skip_relocation, monterey:       "0d2b19e23636af100f7bd6e1e2f0e818a918027991f28c2fca2abb4134a150a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd5f3ff93b2465e0159e15bc027fad0bb7f337d1e4f35faa6388413aff7aef1c"
    sha256 cellar: :any_skip_relocation, catalina:       "0b9d3e30ca6bdec3ef10113324bd831f14d20a88e57b06914a928cdf7ebcc1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a60e9ad81111b090ef2df14bb067a42325255d8337679090556ae296740cd82"
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
