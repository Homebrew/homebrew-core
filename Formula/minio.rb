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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f16d1912be11c97f9687dde0f7802cca0b0ab94ddcae02fbb73d4b21dce29575"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e942ae448dd38b807e6793890c1a33dfb039409e9324fde2c857626b2adab28d"
    sha256 cellar: :any_skip_relocation, monterey:       "b54d7d614912fd92bf80d1055d7bf59188809e389b1202d120d54af1e9c62ac1"
    sha256 cellar: :any_skip_relocation, big_sur:        "69b6043283e7dff1c4c7b80efbdfd55844b32778a551f4839bc5e210a125a342"
    sha256 cellar: :any_skip_relocation, catalina:       "b965f47d2ab0a8e8e008305e191f23ae61d96ebcb62d9f8047e1905d725750c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2afefedd05d5a6111ed1a04713e0a6ed4a602a89a2fe560ceeda3063e290532"
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
