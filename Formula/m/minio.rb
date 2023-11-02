class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-11-01T01-57-10Z",
      revision: "55e713db0a367f6cccee00af49f00c269e6ca619"
  version "20231101015710"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "089a894b6495e620957d8c1624137b3f8163f3c5041bda93cdbfaf10e9e42a64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da63c9110c245bc46242e21980543ef1bb0f7a8990c5cbc10c3efa11c99d79db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5b69dfa8cfcb2da90026cf534cd25d95604bd00240c6a1ae388c45329d1f0e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8586701ea24964c33ff26b395e89bf37b2b10fa5663718da98eac150d05eb543"
    sha256 cellar: :any_skip_relocation, ventura:        "9e84f0a2ff229a590e562b5195abf5f3a1a1fa51e5cd3c7ca9a929f7bcac380f"
    sha256 cellar: :any_skip_relocation, monterey:       "7623a69ad455c32d2665fcf3fcb5e35cbd3cd43d1f847a62e679343f2aca9870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30454ef9493fc7fe2aa68faec4c4dba8575b4adf7b4c066bba0a7624479e0d86"
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
