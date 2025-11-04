class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.20.tar.gz"
  sha256 "6ec12bee3cffeac9eba21d00d99cc1a66ed033a0b69cdbec4badab4e3f545f9e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64624dd8c68970c6b6fa41ec343a114eb55d573dc3a3a9c54c0f082e3eaa4138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f43d8afdf86bbefd9c9e4925d0edb8cc8d47094acf97cd0a823b4a3b7f513c89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea4563c4560fffd22d5e9b1e145272a2eaee3b2fb2815e5ba19e573fe4e21d88"
    sha256 cellar: :any_skip_relocation, sonoma:        "e15bd466e2c81cd92ac43336baf5ce5beeb253c9dff2ba88b45d9a1dec0503be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0379c595c1be16dbe65ae4a6aacce167d678c673602631ce4bdc3835808e757d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "041422dd893b4cef22b30fb2daf68242ef5c17e355b23c24b6763c8f874d64f2"
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
          - apk-tools

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
