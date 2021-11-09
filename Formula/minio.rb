class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-11-09T03-21-45Z",
      revision: "f4b55ea7a70f8a065fb7065797696e815241ff93"
  version "20211109032145"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42468c6643096f95171fbc64106df77e25a7e10fd001213d5d24ab30deddb39d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41ea4418ea20c57e57804d7b9968bd6f56f324c24d687380d803da366397abdb"
    sha256 cellar: :any_skip_relocation, monterey:       "97125b058d9c08e81fd25112a4a0d19d154100e88b1e54ae45274c697ea37b89"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4bbb0cb461669df4a16c4addad1ec42d8b055a9640d2208314afbf55bee0b23"
    sha256 cellar: :any_skip_relocation, catalina:       "82e660c2c3755e8c7721fd628c36a59798da6d0c62e3018be54bebc5cb370f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c206fbed14f169807a0a90c6c2d9e255f860c0c341e6a73ec9f35448e62b85"
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
