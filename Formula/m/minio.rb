class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-06-13T22-53-53Z",
      revision: "20960b6a2ddb9594ee418035b3c7c7fe92ae6a12"
  version "20240613225353"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08e3d908c267fbd152484db751e305f020c5fccbbdebea1dd05f485651d4725c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccab44f46c0d69379b540379a3611c58f12abcd249a3a29fc370c0f85cb95cd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c899ba060bb25accf7d46a76ffb03f893caed350924dc2b6a3d7ed99c918242"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c06cf969a6d1882c4c33edb1260af49e2dbf5834a1ebc7dc9ba79461deea378"
    sha256 cellar: :any_skip_relocation, ventura:        "fa6e99dd043556aec523d515e66bbdbb6d9a45b9bd200c6672cc660aea128a0c"
    sha256 cellar: :any_skip_relocation, monterey:       "2d2473ea8fe35fd668e21371f09aeae0c1e1b01fb7163f0ed3f6f0c31d33906c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a550ecb69bf1770821d147197f06a1e6e1dcc3bde2fd4468549cc43153a20f3"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags:)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--certs-dir=#{etc}/minio/certs", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}/minio --version 2>&1")
                   .match(/(?:RELEASE[._-]?)?([\dTZ-]+)/)
                   .to_s
                   .gsub(/[^\d]/, ""),
                 "`version` is incorrect"

    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end
