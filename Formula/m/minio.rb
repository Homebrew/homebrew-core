class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-09-23T03-47-50Z",
      revision: "22041bbcc469f5ac84207d09b4c4db326ec5fd57"
  version "20230923034750"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44cc5d531423ee79e54f67466d7a9e24611ee9061b105119f881cad848aa0e2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ade4037ac1f7a245a2a1075f17874f04bc3c8d22a085ed2239193bb8f8380852"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fad9973f2b8ada8b6e80f8091614fdcbf7efd732684268fdd17f3a5c343fdca"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8838b648162ae70cc15f712950785b2ab70ff60859a29f66914b460e5d81157"
    sha256 cellar: :any_skip_relocation, ventura:        "0904121b35e9db3a4a60adf81c5539b44fc83239ebe5ac65fc4b9b504969190e"
    sha256 cellar: :any_skip_relocation, monterey:       "ce027c4b7bec1abe2fb013b8bfbd904ad3efafb720fc6b3763571dcd5700ef7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03366feda5184036ed0f1939a371a761d21b80ed46cdffd208356c748518fcb2"
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
