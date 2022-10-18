class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-10-15T19-57-03Z",
      revision: "85fc7cea979b8da1689798e1e290847fd6517c55"
  version "20221015195703"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bf0d984f9c1875bfe3950557b93aec396a98f8fa4b2a79126f171fd7c1b4bc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7c0085555129c009a19e2f6f4febe7da7513219c28382b7bc6f1d1dac0f6b8f"
    sha256 cellar: :any_skip_relocation, monterey:       "b2255a52842a19513021027f961042026b17b7ddb2ce5eaf6f9169e49dd590f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e8ecc2eeb3c136a2c8b2250dc57afb14cde0d0989321aac7e3708c8d86ccf98"
    sha256 cellar: :any_skip_relocation, catalina:       "211e0c6bafef02277dcd908e919cfb83a16cfc844a3a20948e9a17197d3f7fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8361a5741e96a50cc76a7ee69d362630ab66740da2e4d09b21d1833aa80a35a1"
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
