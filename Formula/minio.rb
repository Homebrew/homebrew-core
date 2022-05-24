class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-05-08T23-50-31Z",
      revision: "62aa42cccf39c8b08f394c0d27fb5e2db33f49b6"
  version "20220508235031"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b151b08dd1c78a99828968bbc0017a2446c8a62120edd070d52508af1d205f53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da87a73e9f1082139a951139c400688073b2ac58ccf42f6469d1852e03dc3e87"
    sha256 cellar: :any_skip_relocation, monterey:       "06e2a13d17e1a4e1332f6cea86fbf71141e3aeb19c6b0e7ac4ae7e0f065ed54f"
    sha256 cellar: :any_skip_relocation, big_sur:        "951ee64eab0bae5f86bdbda205b07563587a80475be29b1651727ccb404b0966"
    sha256 cellar: :any_skip_relocation, catalina:       "74fe21d4da09ccb2f0d873d87a7237b3300756140c59be6e6f04152cddc96a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9d78ded68c6ac2a0f2b40c880fe97acb13d54f3f7276beee785a98f126a6685"
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
