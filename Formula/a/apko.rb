class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.22.6.tar.gz"
  sha256 "f8568efddac97570e95b6c495e150e9ec6a0e7b2ec8d32ebcd784a869c83b6fe"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6bbffb4235361af18511db12fb9df4b2f7da70c1f820452309832e34371cb04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6bbffb4235361af18511db12fb9df4b2f7da70c1f820452309832e34371cb04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6bbffb4235361af18511db12fb9df4b2f7da70c1f820452309832e34371cb04"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed1a57236afaaccdd05eaa45f3601d16cca72a49fb34d0358bbe8c9cfb495c69"
    sha256 cellar: :any_skip_relocation, ventura:       "ed1a57236afaaccdd05eaa45f3601d16cca72a49fb34d0358bbe8c9cfb495c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "937e92fbc3f9ed69be4cd4455b641d5a8282c0125fef82194598300022be85a0"
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
