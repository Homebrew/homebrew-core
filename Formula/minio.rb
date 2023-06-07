class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-06-02T23-17-26Z",
      revision: "0649aca2195a8d3aef9b946337b4ca6581e23844"
  version "20230602231726"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bd92587829f7ecbaa5b036e512b012eda3c1d1d28db5745cae06131af24af6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "908e867c45c7f56797a22d3d62da791489d8bb243f5e5d143248b5166a380fae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "770f211ccd2f1f8e5904eaab5e89be1d7acb8cb7db9c011aea4c706ae8c5ebf9"
    sha256 cellar: :any_skip_relocation, ventura:        "3e4f2d8c5c56e3c4fc8bf441bb00a9dba00bf45b4082ff64ade5a0cdea5e2ede"
    sha256 cellar: :any_skip_relocation, monterey:       "3118eb46623e047961437dfad3b95bf577b6f64133bd96c913b7c1c6639448a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "dca90d5c4607c357d3d1751b4e4fb2783cd8b7d3c547920e2768e992ef36043c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79a6bb52715852e1f06ffea976659eccc9b96d96dec5141e8f9b9264a7910e8c"
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
