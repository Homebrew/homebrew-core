class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-05-04T07-45-27Z",
      revision: "44a3b58e52cde6db89fdb99bcc0ea3713c5ad85e"
  version "20220504074527"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa01b57684b1e9a416b8932abd35d075b9a2b1df3208e2d34d2ba18bae5059ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c60e24df7c4d2a89229658b0a044d793ebc734b5346ead2d0fac8bfdb2437e1"
    sha256 cellar: :any_skip_relocation, monterey:       "78de5315e253e33cc30e73b8a4985bf482a6b4f3989f0cc5d817e7fd5ad41bfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0e652e47045463ce3448fdc31b4f118cb89c452fa122e514fe132fc03bbeb98"
    sha256 cellar: :any_skip_relocation, catalina:       "07ff45c2807ae6671929c9cf9fbf9c361fb7a44c6e7401c3d144ed2387986630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e324fa920def1d8bfdf97e560d1bc6c0485abc8062af712a192d6888142c530"
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
