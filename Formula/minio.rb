class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-11-03T03-36-36Z",
      revision: "9735f3d8f2af30e00ac7162bd8d61fddad4b2521"
  version "20211103033636"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dd40fd096eb732ca895c0d1a059661dbe7e3be12487bdb767e1c8eb9988e41b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acc8d613071f385d57f9f19b7be9f466e6913afa96cb3eec954b58fc6f570e8d"
    sha256 cellar: :any_skip_relocation, monterey:       "01e75601c9a3e42bbc12b5bc4061afbab4bc44bff722fd364f427b2f34d5cf8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba1fd0ac2b0c4bd7667b453e1529ace2c9031fcb5dce25cd020149883310ddba"
    sha256 cellar: :any_skip_relocation, catalina:       "dddce8bb1814eb6c1fa29add0d88a54e0e2c211f505d73e595925efc32e7e188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8fd28d6cc9da28e44da1af609eede1ff9659c2acad5dd979614128669025ef"
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
