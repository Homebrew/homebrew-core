class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.13.tar.gz"
  sha256 "646c790d00d1ed603b1621e7da8298a50d8b52e67b7d131d3a3063dfccb148d0"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4f53997bac6ddb2b29c1501573272e7a5c638fe832f4a97d8962d3330e03ecd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4763601278bd670a68265a20ea68cbf7459671ea1da4b32e712d3b15f92779a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22cb9c4f23da9be790d423e82cf1198dc80872f30d4756511dbe1c806601acee"
    sha256 cellar: :any_skip_relocation, sonoma:        "586634dbd6c997e349ccd46567730dadee59cfda87475c64fc71dc8920a82e62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32c4056ae80c07577cc243ea1495b46bed740570cdff0fe1184d3e9d92d405fa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - alpine-base

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output("#{bin}/apko version 2>&1")
  end
end
