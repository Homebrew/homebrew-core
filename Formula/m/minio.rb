class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-09-20T22-49-55Z",
      revision: "9788d85ea3a99eeed8073a57a21ccee71035f152"
  version "20230920224955"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b9784ee767e92cdf84d0f9ee26a4c214d531011ce9eef844386efa39a03b883"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8b8a016990225cc432993e6cd3b856c46ee8dc78b6c115bd335591e5e2dfe1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34549c1467b538f4cb133e95bbae983f9d2cc5eb0cd5157afb111c1817334f7c"
    sha256 cellar: :any_skip_relocation, ventura:        "a12cf0dad78d9c06750701f3afa1d92ca9453dc51bc3de6517aa412838fdb47a"
    sha256 cellar: :any_skip_relocation, monterey:       "e95efd27bd4a69dd92db94a76211dd57db11916c3145d2d3ec5856e80b8fbb29"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f58d50acab897a074668804b8ed9da79bdc7d91bfc522b9af697962b0b114dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9e58c1b7915afa6fc0a106dd4193a6a72df4d897fb2390f051c2b3558de183e"
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
