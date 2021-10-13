class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-10-10T16-53-30Z",
      revision: "ec0fee620843cf8f878d19a00d44c016cc2323ab"
  version "20211010165330"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41cef2139dff90e410915a0ebd58a2c7a4c2c25dcf68ba457301b3ad3a4f20b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "acade1bf63e2a22e4b7b63afceccba935cbc77487d842582d910c06d726313d4"
    sha256 cellar: :any_skip_relocation, catalina:      "6270a9295b1fbd36ca9437a3cc11f73382cc894df8eb7d28b4f4f3e0d1c0bf79"
    sha256 cellar: :any_skip_relocation, mojave:        "def8121bf5735e3f083137c21a528cb266c8a6a42fb2c34743b79a018ca77065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaae4ddd7aa604397310968f7ce06840d4a80a8c0fd69c4ae093c64eac074752"
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
