class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-03-17T06-34-49Z",
      revision: "ffcadcd99e012af6005145fb265ea88a0c3750ed"
  version "20220317063449"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f346340d87000762eec6223399f50a9e6e42a9a03199b57e8966bae58e0afbba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05d0f529cb110a37d3a1a8873b55d0db62e0cd70876e736cb4189e911f6a18d0"
    sha256 cellar: :any_skip_relocation, monterey:       "1383ebbfaf5584ed4bb6aac8cf769bdc68c30a4b3d86ff40e8c7ca64ddc59859"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0cb61c629611658f9492e5332e9d030e64cf0e9326e24c1e996a4bef4273bc1"
    sha256 cellar: :any_skip_relocation, catalina:       "a75a61994c59597d74bb0bb22f9fce4062d1f4e917dd2e992d73b9d09193b15b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73dda3595dccffe6244b8c3952527ab49f249729487f32357102e7a5ac750364"
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
