class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-04-20T17-56-55Z",
      revision: "c61c4b71b26aad048b8f3abe0ee24547964fc49f"
  version "20230420175655"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71a473053911f75f614bdc25eefdcc629e939ac66cd67839342ea2c0b4587721"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7ed34f93cb0842f2d3415e163fda681790292a9f37d3815b97d3c3113a45262"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "822ce0ec37c18bab814d87e13eae0b5d5a34ad2fe612f90bdccf744db906844f"
    sha256 cellar: :any_skip_relocation, ventura:        "d2c0cba7466ce432d84891bfe73294bb3f1cf3cddada4bfe905c90f996bbab03"
    sha256 cellar: :any_skip_relocation, monterey:       "f4b48af3073c9e74540c9f56871292b311809574468ca74bacbadc1b5f43407b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3a0152badfde446406351ec9711e706edfe1e86507fe9f583891d9bd5da405d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e1fd2c96ff390cfbd7d4f3940f8e185fc7c12cb3566072b863222e7063e7ef"
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
  end
end
