class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.12.tar.gz"
  sha256 "dada1825dccf45f60aafe0ed95e0bef4c915ac53e4d986d7e30f6dd2df3ce728"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "974ba89401fc0c514de747998c6cae8fa9cb1caf68c9f986e6553b059f4a064f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4c1702dc274cdc93af52f93bf2823093831e42b8ee64c6433bc940955583b8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "987f9d05798747316353ed1c1a612a30ab7d53ab510f495256e2969cc8eeecb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8cb4103cce7c39ce75023b8c0da65e58ff8fc40beea2ead9e8dc67b69112dd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfcbb9f959b9d399e23031e2cbbcb991109ace0e765feac2c6dde20c10e9c105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11df6a6da9d0450bedca52f619038e4cb4c7cf00f9025933a143b0750cc1dacc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", shell_parameter_format: :cobra)
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

    assert_match version.to_s, shell_output("#{bin}/apko version")
  end
end
