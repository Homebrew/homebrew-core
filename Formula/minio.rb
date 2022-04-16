class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-04-16T04-26-02Z",
      revision: "a5b3548edee9ee183ba4a1e2ebba6baca859af74"
  version "20220416042602"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "853a814a38c41810f61eb4523a2b42dd5df9a8a07c0f50e5bf5e9ec5d065dde2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc82f622b10f26eef059cdb44a727c1b9cb62f48785cc11ce519f400024f3d6c"
    sha256 cellar: :any_skip_relocation, monterey:       "5be42621e726493d341e11c1ef70730ce70932f59d6e3b00dda6a9bc32f9f276"
    sha256 cellar: :any_skip_relocation, big_sur:        "be884e5d6b4995144518080c4d7ccbf0501e4136da19065d4c637974c53a9d91"
    sha256 cellar: :any_skip_relocation, catalina:       "0c0c06dc43a7c4f6d29d80745f244b0e173ccebc3ff86b21b058dec9fa19a72f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02763a8abdab39dfcc0818caf90343095fb2066f516ab596bc4cc2443557c1c7"
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
