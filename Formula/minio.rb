class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-06-23T20-26-00Z",
      revision: "216069d0da24d8a8bfc885344c221a8d91fde614"
  version "20230623202600"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d78df2cc135d09469dcedbd6fd80cda7cc5bdb74effe02740b81cb784d60974c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "becb6d4a4bdb8cebcabe76ce954f864f01f84dd5a0ae0b598ab2ba18b81a843a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68532a2570a98f0344ada142f5d147491c4ad3659798cb4bbcb7daba61a76cd0"
    sha256 cellar: :any_skip_relocation, ventura:        "68adf91bc57bed8c116ad175d39c5e5d9190bfbd4cbf185b84240ab7dd43349c"
    sha256 cellar: :any_skip_relocation, monterey:       "5f46f017445efb4d4fdc4a75e3b8d7e80fb8b2403ae5056ff424631fbf1afe72"
    sha256 cellar: :any_skip_relocation, big_sur:        "2894c76f339289575eafe9d93456b05bdfcbf5a2bdaed43f9882726163c10419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b763ce961b94bd77358a15e0848946ea1e1c430f64233975c7db1b380b99cfc"
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
