class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-04-01T03-41-39Z",
      revision: "892a2040136da86183151b88e3ab1f769dfe207c"
  version "20220401034139"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b6d5d89a6a808b8918f774f88dbb1f138b819aa8035c0d04868105421daf1ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c81c7d0176f990c693a79dd513cb6ded210a0f1912b1e91d704a40eba709793f"
    sha256 cellar: :any_skip_relocation, monterey:       "f6c64a1ad2f4cbec9e532894f9ff5f6e859b756a1a94256b10db41485521b055"
    sha256 cellar: :any_skip_relocation, big_sur:        "89abcbf9084b94d7485f29cf95282c355944c574f929a714947024ea62f97812"
    sha256 cellar: :any_skip_relocation, catalina:       "42f5aa829cb0855e846dbb7e19fcb013773faab8af1e51ada7c1cadcd2f725de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be9f26052286b8ec39a34e70e8194465fd3236307f4660707b272af306569a17"
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
