class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-03-22T02-05-10Z",
      revision: "f6113264f4fdae30528dfc5f0f5867faf0a667ba"
  version "20220322020510"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d9896a9051cbcccbce9917bae0f900079ad28034175e19eda3aff2c61ad9ad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0307e8e3c2643d2b3bd7d3f1bbeab0a3b0134a4a5c7667c469f1ef69adfb1159"
    sha256 cellar: :any_skip_relocation, monterey:       "d6fc58ef3c5986a6cf435a06d5fdd5f26eff13c07aba02fbcdbeff03e72ff109"
    sha256 cellar: :any_skip_relocation, big_sur:        "030b10fa037cfa8abb4ee0f1d248ddbde1b00141bbc806cf70bb66408f3d5a65"
    sha256 cellar: :any_skip_relocation, catalina:       "cc10eddf1fd82ff6203e35e173865349b8f85c3f77e547abddf0d561a2667a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc627e4402627060e5136c2ba7671e262a5b4a21f66ad56331662a09e90a83d2"
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
