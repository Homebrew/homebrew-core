class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-10-05T14-58-27Z",
      revision: "4bdf41a6c70ff5809c3db5c427f3cbee1a725b79"
  version "20221005145827"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6003d82a6d8a1305200a67a8ae4293029d7910eff2e9155555944d07e89812bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d65c4e887e0254aa686953202e482d9ce92df444e9e0b9bb598e92e42a2c56a9"
    sha256 cellar: :any_skip_relocation, monterey:       "90d25a2d4f63d3b410f0bd2fce7463696ed9a50027763643dd3299b9b159e049"
    sha256 cellar: :any_skip_relocation, big_sur:        "b96e7395a2dfa663c5998f7bb9403335017ebbfe1aad7daebf2133ab59f7373e"
    sha256 cellar: :any_skip_relocation, catalina:       "86870b4fd826c9e57ea1d6e8bb290fb5ea97db82a96a6172f743a5bd723df5c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b882fa1e79104524f6f0cb85fe7f67f21185438666170868161a8148c3b19a1d"
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
