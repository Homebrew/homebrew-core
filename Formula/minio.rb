class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-10-29T06-21-33Z",
      revision: "d765b89a63c225ca271ef6d031a7bcc8fe9137df"
  version "20221029062133"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "960522cdc647f9ac4a44f991a4ca1c2829ad16c6c8b6741e430d5d29ec0be723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "440014db760ad871d05104d3853a053858fee712f10c66ff203432182af03ffd"
    sha256 cellar: :any_skip_relocation, monterey:       "e0625a6c44a34638e1af62cdc3fd02781df938b63c159ec82778246da41df24b"
    sha256 cellar: :any_skip_relocation, big_sur:        "369d4c3a0486979085783b71293b880dbd43ed3e5daf24402c13c3d322ba8e64"
    sha256 cellar: :any_skip_relocation, catalina:       "34b7b7f0fc15ba76e93087421f98370cd008026eb5c9ddeae71aaa747620e226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f745df48197686345554b8ca0dd9ee0e5de546c648abc3d080e574935acade8"
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
