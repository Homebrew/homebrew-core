class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-06-10T16-59-15Z",
      revision: "af1944f28ddc5380861e6e88681045c525dc0eda"
  version "20220610165915"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb20a8d2db40db7b509f3b2817d64b7b4186bcc2eb1c53f3fb36e6e8ad65098e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75e26e4b802ce1bd45f06bc4902bf177f3b9fd72e03c87bd23c02c6158676255"
    sha256 cellar: :any_skip_relocation, monterey:       "852f01e6576c4b9f5dbdfc60b7d96fd706adf90fc5f96f16a188e4b379dd749b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fac319375469d84d5b475d5df8e17f549c8ca558ce96d8e4bbf9c9e4406696ad"
    sha256 cellar: :any_skip_relocation, catalina:       "a42bc8d7467be9b15868bcf1d4b7926101bebecc3484b06f36cfac365f2d5dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a0a1f317e49faa558af13fc3be0cf7af9918f416ed26d01f1e382cf1ea8c2cd"
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
