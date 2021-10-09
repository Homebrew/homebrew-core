class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-10-08T23-58-24Z",
      revision: "acc9645249a3ee61cedff832d003421015cc724d"
  version "20211008235824"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bcec828a7602b5f0d050badfc8a69444c69f1584b7045a07d241dfa2eb20c693"
    sha256 cellar: :any_skip_relocation, big_sur:       "c777d6915ca761983d2b36afb3911a72967a0575adfc28417fd3728ffae2c85f"
    sha256 cellar: :any_skip_relocation, catalina:      "e0f9c7dfd00a12ba046400fe920131752ed08b6914d891df158808da83f80b12"
    sha256 cellar: :any_skip_relocation, mojave:        "fd1772ddb4b9e7b4d18cfa6233b7dde6cf44c6df3153c20ed2e8f4292ec137cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e502a5924f45985c8674e08906f871d39ff688ba346f58031a8a242c399d3b"
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

      system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
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
