class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-05-04T21-44-30Z",
      revision: "5569acd95cbc8c7d3fac59cf2aba77baa1b9bbeb"
  version "20230504214430"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78e6c403aa23338bcc867c83376454e401c3ae0689dbd10c8acb3ee5137349cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1058dad15bb01348c123ef8c915e20a34b37b38cbc634c9181d2c11ad4f6d7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83b11e950d4a136866aca2af8580b91d4a78af421790284983b2ecae6fa9e014"
    sha256 cellar: :any_skip_relocation, ventura:        "9c5ed25751702cb0bf935ef8ef3442dd663746cbaa9c62e81b7ec8442be06fb3"
    sha256 cellar: :any_skip_relocation, monterey:       "baef29b9234bee5c4decb8fe3272c7b77c989111a2182313b6bf743b2654e938"
    sha256 cellar: :any_skip_relocation, big_sur:        "36fb511babfdfdf8de70060163f58c88265efdd1cf85f55c541c679362c6a0f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e05084231dc53bb8ca5f03910a79c6f068c9696aa65e1b3d487123e858d72e9"
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
