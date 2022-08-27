class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-08-25T07-17-05Z",
      revision: "18dffb26e7aba09074704d169517285ac3870e86"
  version "20220825071705"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03a03a4f633608298f660563b02d5742ec319e434aef417a4a5ccd584f72b23f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d6efff6909f3155dbb3db55c92cab286f3b8112a287f4618b81a41061e8969b"
    sha256 cellar: :any_skip_relocation, monterey:       "0503aa965d3f79e246545d35aab66d11651c5c114097f619962fceb605cd9a0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f37e11c88b75c207bf5e9c54247d8d42a16d5e13944fe7b6b292290491eecca7"
    sha256 cellar: :any_skip_relocation, catalina:       "99a22316dcff00bda0027c01ba6553d90ceee947d493fa1cefa624b4bb10a4d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "724a50ae86c3324352eb3df1a654f56519b9f88d2b8a31a7d078e262f52b9885"
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
