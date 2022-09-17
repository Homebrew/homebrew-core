class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-09-17T00-09-45Z",
      revision: "d89f6af6c4ab280140627974252077fba47bbb79"
  version "20220917000945"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c371e76b2cb222439a519a7b8b3c6f735f70d424385e06065a49203a8047ea93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d9b04192778ba88aa214f929ed16ab4776aac24ffac84d5ff32b9a72fddf71d"
    sha256 cellar: :any_skip_relocation, monterey:       "7c882c8ee76b0b104e4dc14b282568ddc15a4259bb205661eddfc978a58be327"
    sha256 cellar: :any_skip_relocation, big_sur:        "0549d5009fe25f4b9e067cb55adf2a290089541baea5c3b24d965241e2d5c799"
    sha256 cellar: :any_skip_relocation, catalina:       "b998ef7243d20f049774f4396ad5398e03c4da0fec78bc4262c0330e30041688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c23efeac6cc46a5869988e5a19488e278264322a1f965c938a58a6e1ba59d53"
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
