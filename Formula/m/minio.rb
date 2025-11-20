class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2025-10-15T17-29-55Z",
      revision: "9e49d5e7a648f00e26f2246f4dc28e6b07f8c84a"
  version "2025-10-15T17-29-55Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e2fa706f5b973ff2927c21538d1e0be160aced2d5f646742f40291a7529d484"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80b0d45a0099d2077e7b1c6b219c74a243f5a50520aab2973f54a46843ce7f53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac206377ae9be883cd86cab99f522898668608614837eee76cc9ac657d3e9233"
    sha256 cellar: :any_skip_relocation, sonoma:        "54154dcdba031f5a053608848ca767dd7549a1c1a2d7fb419c09d0e7f8c463c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9111c9baff73c9c8e552b1147114b606fddf35ffb0e4e164085ab5b715b277ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eec0924999ec02512516b58be63a3c29dc75a2d9e46494d4f6197d457d7846a"
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
