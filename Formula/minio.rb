class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-12-27T07-23-18Z",
      revision: "bb97eafa82544de7d78e8b614fe13f9754f58d6c"
  version "20211227072318"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dc5c7dc308edc367b20ef845d4cf42bdd1d1202e457189d4538efb1aab6fbeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d4abcbfe3a1951f98941412d45279567636b7a10f0ab02efcfcf5d04cf6d0e6"
    sha256 cellar: :any_skip_relocation, monterey:       "09ee4ced898a1612d949e807f7f4fcc238f367b1929ea0fe32d0e2a12324ecb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e069dde2b7f9e6a87d597c54cf105b104d6e638cc5bff0c0774122c2950b07c0"
    sha256 cellar: :any_skip_relocation, catalina:       "8455d4d4a0f870c943851551a9719c4e33e9654194fa9042d778079ee3e116fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd5ba4f0ac160ede11d66731cc6bcbe7cf5fe34a4339c9ec40ca9fe8aed33a2a"
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
