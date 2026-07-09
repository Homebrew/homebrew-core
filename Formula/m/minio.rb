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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f399aa93691336acf3ef6f79c08f97f2d43784ecf14d1f535c77bd3813082ee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70f9defde59619293b7a906256a5ae47901e138fa3d34e56f37254041adee9ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8e0395a3145bc094c61b7da79df655d708d9c610b8aec82d765fdeca940d6cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fee9c7ff052812ef350126d9c1d7861072119ac4f3443025260c42ef53234fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4097405967ef5849556ed9d301a74545d53a725bd64fe8617dc5d3f039f4f77"
    sha256 cellar: :any,                 x86_64_linux:  "a36e522f309bb9a9c4487133ccab4c1b8c62b1f31f5afb177f090ea3e3eb78e5"
  end

  deprecate! date: "2026-02-17", because: :repo_archived
  disable! date: "2027-02-17", because: :repo_archived

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

  post_install_steps do
    mkdir_p "minio"
    mkdir_p "minio", base: :etc
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
