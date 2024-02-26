class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-02-24T17-11-14Z",
      revision: "c2b54d92f66ea02642be4ede26f2b7ecac1f2056"
  version "20240224171114"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bd060c78e86ef0170f8f5c389604ff61815e58e968c8d15be808637c15669e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab0247e27379cf010c8fa29e79412287d6fdcbcaa906d5aac15c0fafb0353400"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f52b044b97df982aeced9ce1bc993720c188656c61bf8fd9abf0451167447fdf"
    sha256 cellar: :any_skip_relocation, sonoma:         "eacdae3facec8f6cce2217fe51bb21a47ddfaefaeae92e79a6cf15eafcf6c6cf"
    sha256 cellar: :any_skip_relocation, ventura:        "dba9c2a782f42d4d165b35c0f13ea43097c615c1775c70c412021d38c5951586"
    sha256 cellar: :any_skip_relocation, monterey:       "9d94aa6bcaf28b2f4cb5019a46be3654771ef4946de8884b1b7fa4a5c3863d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd1b372c7cd048e3f47aca55eb863459a7672655612c7a6d0eef1dae5eb6d957"
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

      system "go", "build", *std_go_args(ldflags: ldflags)
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
