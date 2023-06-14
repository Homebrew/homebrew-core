class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-06-09T07-32-12Z",
      revision: "6b7c98bd0fde630c6aee78d702b9d37b0200f52c"
  version "20230609073212"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8204cb3908ad23523758918e77c3de4e9feeee305a36b32f74dc93fa54c3d0af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cab5a80077b5f74d2cbacc6e64946336123c10004b3701135906cb7e57fae815"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f69c3faa3cc00a64741427413d422fd5e7cdc9ec98327c4254b2a0d3ebbd5f6b"
    sha256 cellar: :any_skip_relocation, ventura:        "4e0d4d443510d355615583568b8df7011c9f86f10f0190422bb6786836870821"
    sha256 cellar: :any_skip_relocation, monterey:       "efbc3e73beefb53e0dd9092e6b578364f8ec63095a9e6d59c3f96de034b42d60"
    sha256 cellar: :any_skip_relocation, big_sur:        "51762560069862d0d1523c76ac304275cde35bbdaa5111d3e7c4b8782e411233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c9de44848de36e05984e092ffd0a7cf3b920564f7bf6803558396e900b9b506"
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
