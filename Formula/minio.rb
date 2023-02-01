class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-01-31T02-24-19Z",
      revision: "2d0f30f062e9ec3da8887e5ee64f59f5cea03240"
  version "20230131022419"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbb0451591d7183017a7dfe9afab19d263e6cfd15584146401850297f614c353"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df4eb10b3fd66fa9f24ff3f5e1f08f01c8de10b03a06a0b5f005a9f247dff1fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfd6d312445ad699ae956b43323de6100ffd8ab5d4e2dd6dc4c5052a017deb9e"
    sha256 cellar: :any_skip_relocation, ventura:        "6b5f7b43dea2c091201676ddbf91a8723b15a4cb2af045b5775b8baa669e8d57"
    sha256 cellar: :any_skip_relocation, monterey:       "4fa78a7726a129ec6dfffeeb9732668e6f9459c251192e7dbde71a2218058234"
    sha256 cellar: :any_skip_relocation, big_sur:        "dec7091d655ca04a56fb4cc7ad6a8b401e32541cab403fe0dcf3be642444e241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbd43a179bed6c51a89a04d729153cc5a4faa1a67f17bdf42564fd42c17c0627"
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
