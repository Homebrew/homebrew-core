class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-12-02T19-19-22Z",
      revision: "5655272f5a62f827e6baea6a4cb21a4c3f065c2c"
  version "20221202191922"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e63d552b9c54e568de26a6a1386e35c0d2f97684bcc533b7b9661579bc2f072"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "948996a09ae31b304cae82ef072f1dd51a74d5767ee7d82a69bd3577254a2770"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c659ecf658ddb88414ac00c565ff5290c92bd5bed8fc99fbe9db283eb42c8d8e"
    sha256 cellar: :any_skip_relocation, ventura:        "f0af497bbb7db7a93e1f55a8c0b5fa730f89490ae68406cea8e8574313a801c7"
    sha256 cellar: :any_skip_relocation, monterey:       "17eabf1876a656ef16d4a14b832532e6b229081f53f9b2f9b774c0671dd8b0d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0cfadb66c81efc12b2dc73021e6eda7fb6732d848b7dd71b019f47210df418c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ead3db07b9087980b710499f97b99b0dbbdc768460464d65bb7f489362e918"
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
