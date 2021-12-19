class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-12-10T23-03-39Z",
      revision: "f2bd026d0e531b35b553b3f2f1045b85189eb8f1"
  version "20211210230339"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6be0fec1c75b3a7838ddcfa682d756a4e9b4536db794cc6c39ff4ffbeb80601b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1864924faa5485b29b1c6e7b956e302acc773d1ad237b35e8cc36e8493b9660b"
    sha256 cellar: :any_skip_relocation, monterey:       "d3371e3888cb97d885613318f1c86067e35692435782832b8084351c87eed2fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "15df00c11ffe3259c5cefbb84f710d7cde65854459cf03dd15d713ad748afb44"
    sha256 cellar: :any_skip_relocation, catalina:       "93b9b1078eb3c54d0047155c45ddc7fd0c9c18ad131014be0186afdabe4b4dbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "847308df782e71b65ac4607bb2d062e9755acabcd6f491294269f643e51e4f0a"
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
