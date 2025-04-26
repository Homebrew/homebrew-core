class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2025-04-22T22-12-26Z",
      revision: "0d7408fc9969caf07de6a8c3a84f9fbb10a6739e"
  version "2025-04-22T22-12-26Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69f0f37fb7db353a80d3087cdf9ff81b6360ddf7093f5a4afa5be83e4bcd1286"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7f55c4ab143390090946862ae237d929f76acbdbbf4feb2a0869f59a1c02c68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1efe823c24504e9001f70788b843f10c6ba9238ae6f26baf99dade55c46f745c"
    sha256 cellar: :any_skip_relocation, sonoma:        "617e0a7dd68d74177f009ec9c6204357c25ece9c0dfe39fc4a39eaf429a7b9f5"
    sha256 cellar: :any_skip_relocation, ventura:       "9085d34412161f4bed9faad79c08152840aa134d50f02790e486b65bba82f970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae2e80eeb88ec3e0220104d49ba55c32c134bc5b20af4919eaa07414e91494fa"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      minio_release = stable.specs[:tag]
      minio_version = version.to_s.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{minio_version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{minio_release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
        -X github.com/minio/minio/cmd.CopyrightYear=#{version.major}
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
    output = shell_output("#{bin}/minio --version 2>&1")
    assert_equal version.to_s, output[/(?:RELEASE[._-]?)?([\dTZ-]+)/, 1], "`version` is incorrect"

    output = shell_output("#{bin}/minio server --help 2>&1")
    assert_match "minio server - start object storage server", output
  end
end
