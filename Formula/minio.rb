class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-11-05T09-16-26Z",
      revision: "8774d10bdf25fc345e9deaf51131e3582a7f6e23"
  version "20211105091626"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfcab1879b007bb5628a84f43f946eb30ab54486c1f301d41e4e22841e0bdd39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12e6168400957925a1343ead58d9c5832fd5d4b96afdb81613ac05da58b291e8"
    sha256 cellar: :any_skip_relocation, monterey:       "ddf9d8dca94e43c6c46cb3ea6fecea85a511428476c12bc70a6ec09450e82861"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a02339e963c97377094ad8fa224b273d46d4b96aa5bb380c0ffea88f10ffa8d"
    sha256 cellar: :any_skip_relocation, catalina:       "d543228316df6d9f1bce375f2b008278f48269c035ca2da74186ed3e9c9ab99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77b23786375734960fac6b3dd7bfd7d2842384fdee2e5cacefb5363a342670e4"
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
