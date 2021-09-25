class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-09-24T00-24-24Z",
      revision: "769f0b1e24c42d6ef1a370a5c657c9f6d5484fe7"
  version "20210924002424"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb8d090bbd86e5865005e3fe51b7985519c0160f87f5aa997b4a72eee2db63e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7bc829526c8c1fc59199f7e7ae3a43af3f2e4e835b7f585dfb5cc713d6867e3"
    sha256 cellar: :any_skip_relocation, catalina:      "69ded4b16a284c80caf32a141c6970486dd4bc06e1003c1086d93a9afa77c2d1"
    sha256 cellar: :any_skip_relocation, mojave:        "28c3d005ede3272beedf6a883fe943c695a00210f0070ba53b5520fc942f5db2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a6ec350cc8b057481f8aac36a9b62fd2e948a64c1ed2c4e83bafed5881c250b"
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

      system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
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
