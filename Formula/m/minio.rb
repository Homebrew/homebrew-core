class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-05-01T01-11-10Z",
      revision: "7926401cbd5cceaacd9509f2e50e1f7d636c2eb8"
  version "20240501011110"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7988b2973292e4e1d9ceb0a36ff33cfa154e3cd8661df416ec2618cdb0175987"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1faf1053703b62467295a530aefa64125feeb3db08c19a4655938df27bf0670b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa64fd597008685cc42a3ddb0052229b57f45ebb6d9948696f2c64a548f906a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "86876d68491eab1cfb2a723158059d2c07c8336dfe88fcf32bbad1a8d59c8c3d"
    sha256 cellar: :any_skip_relocation, ventura:        "4c3d028262daeea39349d8634d2b75c1d0e246669b5d03803aa77555e3d3964e"
    sha256 cellar: :any_skip_relocation, monterey:       "7fd6259e2bef89991a2fd791c890ffb258989904515728f091e901ec90b5b584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41e139489ef4418ceca250fdfc3e9890905a556d7f133acad8c3923eb7f5cd5e"
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
