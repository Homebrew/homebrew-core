class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-08-25T00-41-18Z",
      revision: "f00e8bc107b0e83029e89238330ec02fa85e065d"
  version "20210825004118"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dde7a43f9f6bc6f6e132c25d69b366afff2bd235b6523669173fc22ad74f354d"
    sha256 cellar: :any_skip_relocation, big_sur:       "31c805651d0cc32dbab14dba965fda53f1e08cebdb2b89ef33de9015882ded79"
    sha256 cellar: :any_skip_relocation, catalina:      "f1a5c803fba0142e053fa1a6c8e392d1ca443e70212db6a3d4f0be5239197d17"
    sha256 cellar: :any_skip_relocation, mojave:        "4d3aa6f2e7ee28e6468c44a9ec36d1c538b2efd523e35466f89fe4e1cfae4d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c00844100f267b3a90f0b8b8e9d848146ccfb9dbded335320762624e761e71"
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
