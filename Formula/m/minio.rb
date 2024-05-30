class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-05-28T17-19-04Z",
      revision: "f79a4ef4d0dc3e6562cad0d1d1db674bc8c75531"
  version "20240528171904"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5acae44bd3c8241533f3d246144f7b713eacef2998f25ae14ef924e9dc645ff5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86f81462a73723f0842a85c7fb6124965247c50fe663e5a0c4719d029ed25031"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e8245dd78dce00537fc24fa7ee7c8749764d6678f2da02a8c20fa31e5770264"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fa4474b01b162f46d98580e432a1671879399b057782942a0992df6c9ef59a7"
    sha256 cellar: :any_skip_relocation, ventura:        "d637402347ee4314b2610c2ec5f336eccbbe33f49fb3d75ab8b7640d81014e63"
    sha256 cellar: :any_skip_relocation, monterey:       "fa04d524d2d9e738321e4806bba4eb00d2b6d94f8457e05dd09ead3d7324c6b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b0fc6a051fabe3d55ec74cb1a79ce2ce0824ecd0fe0a87f949b14664e8d0b38"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags:)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--certs-dir=#{etc}/minio/certs", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}/minio --version 2>&1")
                   .match(/(?:RELEASE[._-]?)?([\dTZ-]+)/)
                   .to_s
                   .gsub(/[^\d]/, ""),
                 "`version` is incorrect"

    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end
