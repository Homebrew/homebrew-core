class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-03-21T23-13-43Z",
      revision: "7fd76dbbb71eeba0dd1d7c16e7d96ec1a9deba52"
  version "20240321231343"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ff02ee0ce1e8272660527087ecee244ac5b0ecf9eab67568436ff6b26255456"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f093125f7b34f8c2671d3269a9b9c9a7113ef5dd7b41b1789664312ef1f70cbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59c670310bf50508b9efdeaf0f3e396f61ca6930b8d7a4cd85587a365d942891"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f2a60aa92a0dcf0c780cf822e5e0719152197ac161343edf046b3ffb5c009d2"
    sha256 cellar: :any_skip_relocation, ventura:        "ba5a0417016160c66be415f9737480892232d023b919d08918fd7ca854511429"
    sha256 cellar: :any_skip_relocation, monterey:       "b5a316a9695258a6805e441cd8c6230795fb6e5f023c115249ec016493b6f789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a47c2c4222e9616ee47bd43cf56b5aa344581f2445c80aad021753fe6a615cce"
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
