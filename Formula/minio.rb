class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-03-24T00-43-44Z",
      revision: "c4335725857aed560d5d25a8b397360a78cbb023"
  version "20220324004344"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "499cfb469efe700c7b504f337b71c6e547dc731eb68c4cf628c3a6e2da927610"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49bf8083d780119551e4b37eafcd379609d73505dbfc69828454295ebea625e3"
    sha256 cellar: :any_skip_relocation, monterey:       "1ed696b9fe7d39791bb20818ad58db122313a7212c8af9f19fc1a813b3fd2bad"
    sha256 cellar: :any_skip_relocation, big_sur:        "b12599a18501d42549bb728c3d692f0ad4f14938e7ac9414d7cf4b05bcad14c2"
    sha256 cellar: :any_skip_relocation, catalina:       "8f18f720f0371dff836eae00d58abaf55f3973fe3d2a7b17a00b9066fa3cb9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eac065d30af37e4b17dee45ca4b95214edd99563cc9729d01db9cff86b13623"
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
