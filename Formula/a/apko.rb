class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "f932013cdc780d46c1512ce04579d9165778eccc94a4b343848a63ecf4379b81"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25e055e3394b4869e8ed8ac59787b1fa4245ac25955eb0195c2664f1eacf94da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c331a6937f4444c45cc0d89d42114d028a6445cd015660f10dd6c314bad5fef5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cbadcb18c48197872ca989403cdc153ba04c40f88436187cc9d148924e1b218c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "996a256253f254133e36ac925aee4353e7c9329644c10aeb3470b2efafa83571"
    sha256 cellar: :any,                 x86_64_linux:      "8bd7e3ac9121802a9a8d8e66165c99b5477c0da4b8091f3b13d28353e7cf875d"
  end

  depends_on "go" => :build

  # `test do` block queries Alpine package repositories
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
