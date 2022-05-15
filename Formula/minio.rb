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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e99e11d8a77b9d285845aefd0a06c5bf464779b24d370d74a4ae1f505fd86f20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2df2313b6bce07d89e4802a99b132751c667061e80965942a6bdf2dc4c4e4376"
    sha256 cellar: :any_skip_relocation, monterey:       "6e1aaea36db5403f5fcc3fccd80c9c799b3c7f7c2203d134fc38983fa29253d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8f293057f1ffb91655cc07904b74162224ee0809d3552fc274ec7c4dcbda15a"
    sha256 cellar: :any_skip_relocation, catalina:       "13b505ea496dfb01dbb61ba9d5dd7c12761b41fcea6135619ef3e587da35f478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd9a4568865636dc32a2ec9244f00dfa902a993c291ec0ccb7cdbf3649acf104"
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
