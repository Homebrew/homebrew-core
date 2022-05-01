class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-04-30T22-23-53Z",
      revision: "c3f689a7d9d1fdf0689117a32b5954f589453dac"
  version "20220430222353"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c3907156445bafad7d43108443011bb717b3c7b06224cb1112ae8ef69d928ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69857bcd4631f78f672fc8a06623559d8c77d65b3716617046910c7f5fea540b"
    sha256 cellar: :any_skip_relocation, monterey:       "73fefeebe829be6e521c68320e3967c1854b7205ad8aab681f5f125677c8294f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0155d6d8b555413fb118a53101fd71c42e26138f77c9eb149cc1cdf86e5bac1b"
    sha256 cellar: :any_skip_relocation, catalina:       "715254670d7d7b2d2365d36a45232bcde5ca6980ac99b3318fb33324a5b47c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db5db85bce5c8f074ae9006dab1ab0cf9dcfa9214a10b19d7bc646f7b175ea1d"
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
