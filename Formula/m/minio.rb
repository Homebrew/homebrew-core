class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-09-04T19-57-37Z",
      revision: "1c99fb106c3e1448ed92f8465d5695d055d432e7"
  version "20230904195737"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a2c2211b548f0230d9ba14a3d2c9ff7d9175cbd03313a0d96135bcc35764604"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "748525762dd02aec0c7f1e7ff559afa8a23b56bf93edf34d32ab8cb2cd1c4b76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a14f80472b68231cd3758b4e08851dc06b43fc8b126300a7c5928076791837a"
    sha256 cellar: :any_skip_relocation, ventura:        "35d5bb44f619655b2e66338ad95874c504294e32fd7cf558e85eef620de86cb8"
    sha256 cellar: :any_skip_relocation, monterey:       "3057dd6b1d8e6cbce4db88306a1128d6ef348c854979a0254b0564eab598911a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9197682f28541edac7201bb62d619cb4f4b1d5fc53466fc9f79d710f4db542d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c098b016cba1058d3f3b6f879453d405ecfa751489b2294754caf1248289ce3"
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
