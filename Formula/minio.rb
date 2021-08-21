class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-08-20T18-32-01Z",
      revision: "6d04c9c585575899a788604e3758d9736ecb0326"
  version "20210820183201"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "70265104be2ff608e51e950acd1d3d64c55d8889e29cedc8ee056069d22ba83c"
    sha256 cellar: :any_skip_relocation, big_sur:       "13d7da64d9d83d67600f3edd4e49212b79b8db6ff65282222f21574da1d00c8a"
    sha256 cellar: :any_skip_relocation, catalina:      "f305a18a4fccffae885ac8848ef6367bb9072e6cc5ca7fd6a0d2421cfe9bbd57"
    sha256 cellar: :any_skip_relocation, mojave:        "dc7bd51656b5c471cd569bce0b65d2d68cd0249dac5d16bd4c2891fdeffb4f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6744e8011d68979acdae2f56781dbd35e03d9ccde00ae1c8012a25b8b8eb05a2"
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
