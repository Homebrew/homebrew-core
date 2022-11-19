class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-11-17T23-20-09Z",
      revision: "a22b4adf4c5cc3e4db13fe92da683ef1ce45cd5a"
  version "20221117232009"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e389f2e43878c8aad4bdb7538f78770627c068da3b2898453587a87b92ad740b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b660099720cf24b87f21303153ee6683704d0cf625f421896d51fa0214bf8fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ec17c2b2ca5d0a251c2c650c28342e96079a8ea927bab3b82fef565d036f2b3"
    sha256 cellar: :any_skip_relocation, ventura:        "41315954779894f78e3a2259b0175a27708991de4f5596aa830b9d4277569ec5"
    sha256 cellar: :any_skip_relocation, monterey:       "fafad27dbb6e3e59f804a6270e81562bad5b8e3e3e814435222f64357e412fbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a6e3a3bfc4a6a41580117f3968f415bd9336a270c4b257b2cbaa49524074967"
    sha256 cellar: :any_skip_relocation, catalina:       "9f5c71e80607372cf3d9d749afd4f8d269215402276cc0b476acdbba2f8cdb54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d06461c8b5b08b1f803cbd96139f315bde1ee84a8134250896c0f1d16df0055c"
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
