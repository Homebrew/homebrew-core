class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-04-09T15-09-52Z",
      revision: "601a744159fda388eb6fe2fad315dc9c6017f94a"
  version "20220409150952"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4814134a3acb212e9e61ec1c8f58dddd5a6bf01ac4caa78e5b01b6addb800540"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "726498b4ced9144f5295901205001f71555ea0db0d5ce93f935c043e96250eed"
    sha256 cellar: :any_skip_relocation, monterey:       "fe38a92cf63a79c565291d59c106d0bc00a1b89f4d6ec24d40322badcaa4c4b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3686532388af848efadad81ba408a10077bb378552882cafab397cc41700fb81"
    sha256 cellar: :any_skip_relocation, catalina:       "757455b7eb16dbd75caf90afe0f8ae243feca2ebe8e0d255a18f968b4bb41823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6ed40315874dd59d925847556cba869bbf06bea3c96f3a8658454eb10948f3d"
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
