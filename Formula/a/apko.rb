class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.10.tar.gz"
  sha256 "46f4bc9936d838098ecaebb30cde2f046ef0230b363004c9663c4211c100e68a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d7b02b792fa04ee8ce56d36193156d5ce5894782552a13e0118366a0afc65f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e95c36cb1064ea92bc30a50b8606c78223e167f3ea4ac6c97794bb0ede4811ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "536587b84f75f802f2f20867adae43f0e018d644040c89dea433cb0911eee494"
    sha256 cellar: :any_skip_relocation, sonoma:        "b89ffabb2303d63255e012259f027575558cc8bc0664ed450193a8d69e3142e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "714a053391f5a67da880d873d2a60d033b9798880288d573224d56f3586f74db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69ffb989f37fce01143c2dbc1015114f346ea1d417d0baad28f8ecb258893634"
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
