class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-12-07T00-56-37Z",
      revision: "04ae9058ed5b135c27a3662b1153e129e5cf1483"
  version "20221207005637"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c504dcc097c4cd26b0c5eb26fa32e37000f6b7366d98cc33029adca127535e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8f7e32809a0dba9964abb06c270c4029484969a46d66ba32c09f4bf2efa355c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a5da39439525783d1c43e4a88d26b9e386c4e895c9732c6406bc9711ff6c2b4"
    sha256 cellar: :any_skip_relocation, ventura:        "f1429c562d9f1c0f1728e1dce789cbfda2ad0cf35823c62fe0335437b104df7c"
    sha256 cellar: :any_skip_relocation, monterey:       "90263e108c51a2a96540b93eea33ee08f0c901e0f455e70bdd64dc2c8e595d00"
    sha256 cellar: :any_skip_relocation, big_sur:        "370c55b7d621813821cdf3927921cb21e9e435a48fd039abfca28cb38071feaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4af0a2feab3ff7234284662cbae70023ad84c412077934c6263c1561f66be30"
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
