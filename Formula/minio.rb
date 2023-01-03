class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-01-02T09-40-09Z",
      revision: "1cd8e1d8b633550e18a108a0f042941afab6e923"
  version "20230102094009"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1774a52d7a214023742a5e0033ba6f8c378a78bbdc31181b9f2893b16be5cfb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46f7a4992d1aa2d13a636b8c973db3dff65787d69e35cbd3bbc16f373a5de481"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2acd0c45c41f47dc689adcfada810cb6c4a8c5c468ecdf3cf2aabd832c61c167"
    sha256 cellar: :any_skip_relocation, ventura:        "4f533000bb351320af6e24d595db121feda6671eeb3074513f7b372d85527844"
    sha256 cellar: :any_skip_relocation, monterey:       "a0ad27bfa825ea575d8a708a5779ae7e7258851694358868858c6935940fc679"
    sha256 cellar: :any_skip_relocation, big_sur:        "be602f702797b626eab3217eaf15b514bb99a10106df95c9e28cb6b9444c40c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68842e89d3945efe16de16989e1c24d06806b0f43ab51623e90cfdf156665773"
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
