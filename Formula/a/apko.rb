class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "cee42a07681c743ef19418e39e785b53a2b15410629441d8bc6bb949e18b012a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66929382d06b7c4b2b31b169887772f65aadfc5492b911735bfe61465257877f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66929382d06b7c4b2b31b169887772f65aadfc5492b911735bfe61465257877f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66929382d06b7c4b2b31b169887772f65aadfc5492b911735bfe61465257877f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0204b14b03355bb65c193e217aa26b5673d208bcd721957fe56f942c0086759a"
    sha256 cellar: :any_skip_relocation, ventura:       "0204b14b03355bb65c193e217aa26b5673d208bcd721957fe56f942c0086759a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "713f08cd8eb3b2a5fbf55c8132081e77afe0c9b6855f6b665344a25e80e29253"
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
    (testpath/"test.yml").write <<~EOS
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

      # no keys found for arch loongarch64 and releases [edge],
      # so constraint the archs to x86_64 and aarch64
      archs:
        - x86_64
        - aarch64
    EOS
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath/"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
