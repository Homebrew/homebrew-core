class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-02-18T01-50-10Z",
      revision: "65b1a4282e6af07d1a6e644ef4397d76f635abb5"
  version "20220218015010"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a161c913eb19d2c32324caeca36cca2ade93961522c68d1d0ed0be9b93fd144c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8576a7229a2c1a8778bdd5c1dab52e8f40663b76d6caafa1a7de644d56dd5fac"
    sha256 cellar: :any_skip_relocation, monterey:       "432f85a0aebd6e3d2bdb8c6a6e634a3eeacaf685b54ae518fbafac582db19472"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd782f18dd28405f261687b77a26144dd9120200ba77a04a203025a6a7b3411b"
    sha256 cellar: :any_skip_relocation, catalina:       "6f1eac1e9c77eadf08f0a7994727787d148cb027f6d628f1f7a200d18f5e3ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75d1070d5032141eb9db8cddaa6c25a168289320cc0b7ce851757376402177d8"
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
