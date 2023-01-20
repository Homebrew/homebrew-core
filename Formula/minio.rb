class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-01-20T02-05-44Z",
      revision: "0f591d245d3a1810b0e6aebbf3f32937227f68f8"
  version "20230120020544"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03325094e239f83200f606b6924b726da9adbc5c6b310e1c4d8b70d1d8a9e6d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b7ec732a34a040e5a51948bc6ccbd14026ea05229e88d9926362ba823131b93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96cec44c89e2475af9a2fe6968c15abe18419795c30a790f1a43519d60484d8d"
    sha256 cellar: :any_skip_relocation, ventura:        "7f04725497cc605a010f80a2151e4a38b522435595836473d9a1b97bae4104cb"
    sha256 cellar: :any_skip_relocation, monterey:       "5b821683a93886aa81a3b4c902bbcdfee29214cae6c0c46a0c95de18acc6d260"
    sha256 cellar: :any_skip_relocation, big_sur:        "e319c239177821836ebf1f75af2f1b65ec8b4b1ea184f2f74dac47428d6c201f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fab2076f333a41460767da2d6e6913ebfcfa5aa4f7e876fb111e2fbdfa0d325"
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
