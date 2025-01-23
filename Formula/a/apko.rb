class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "d7fa585bab0a96039a4eefd06f3caedd52e2f58f818c2e0fe6c2204735f4b456"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cdeaf2ec8cc41871b5b2a30db47562acc4d644689d7719ec05f01ad9d291119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cdeaf2ec8cc41871b5b2a30db47562acc4d644689d7719ec05f01ad9d291119"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cdeaf2ec8cc41871b5b2a30db47562acc4d644689d7719ec05f01ad9d291119"
    sha256 cellar: :any_skip_relocation, sonoma:        "6332d56eeaee6946127d1080de1571f9fe1144fe2e144395acdce65167d635d9"
    sha256 cellar: :any_skip_relocation, ventura:       "6332d56eeaee6946127d1080de1571f9fe1144fe2e144395acdce65167d635d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ff20f14f1beadcbf8630f821485fda095975b58bdb24ba394f7d5648b13d837"
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
    assert_predicate testpath/"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
