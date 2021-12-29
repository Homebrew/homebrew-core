class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-12-29T06-49-06Z",
      revision: "46fd9f4a535b6bdd32716e29961744aa86240661"
  version "20211229064906"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a69ef4745d909672123df158c9fb501ec1a2b75480a4ee2de91de80bf20446a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a70ef960918a9484a083989965483ab0bdab90a517ca14097f0e7a383b0a3ac5"
    sha256 cellar: :any_skip_relocation, monterey:       "c2c7ea0bfe502d42c3d9834146af9e372da9aad7e49e218a448c353c32f10b45"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6d12b58b718363d2ed8fac887a48fe84e3b0b94d570d1bcd0cf5b77098ec546"
    sha256 cellar: :any_skip_relocation, catalina:       "ed37e669ee3e916569ba46168c7cb3485313c55c308872a5f825902363899ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69f89947ade7a4e6657433e244878b3ca2360156140edae079e64b008d731824"
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
