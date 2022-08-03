class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-08-02T23-59-16Z",
      revision: "76f950c6632fe67b17e9f0cc00905d7093ef837d"
  version "20220802235916"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dd66910e20f726e87af2d91bb93822cac7670a49462448a87dbe13b6ef13080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d95340952fa533bfc4195992038835c71e51f0f55297db8e4c974c0469b95a87"
    sha256 cellar: :any_skip_relocation, monterey:       "1d7a823fa1f40f1c441ace0be8a29fa71f9e9e29ab0ae46b1f808c311b922f0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b2da3575419650691489a343c9a0bb45aa0686d8fb64e32a3caa91c4951f26d"
    sha256 cellar: :any_skip_relocation, catalina:       "783b7a5dfbb951d22691f0a42144c90e39c1e0e1c79279a8135dba3820da6730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dc1b8fd0e344d6804c33359c8f62310eeaaf66c13f0c2ec56872d12f25bf38c"
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
