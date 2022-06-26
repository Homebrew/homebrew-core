class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-06-20T23-13-45Z",
      revision: "b3ebc69034bff982ca2c1a6ca43afd20838e99d5"
  version "20220620231345"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a2b4ffd4934d59d8d3504aa935699d14f024fc87ed2076c4ed678a09c2e87b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4a1601f9626eb004a8b37b74e6aca9e27bee3e3b9c7278ab0ed076e9f38ae06"
    sha256 cellar: :any_skip_relocation, monterey:       "acabcca37bb629d0924e52a5e493e9e02f2809d11857b2e6ef44d2e6f09d5288"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d95d61950754820055e423fd7722e70ff415315efccf6872099797202681084"
    sha256 cellar: :any_skip_relocation, catalina:       "ee6f6e8929e6cb1d48989e1ae322253f6a68584b301c2df1e7d8e730b26ef50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37584a7db62b79d594655d7c090556d92e52883830ea29282caf0fbaea2b47b4"
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
