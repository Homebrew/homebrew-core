class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.11.tar.gz"
  sha256 "64fd793b9a693ab0976b43fded8bddccb6dad341daf05ca107bf7a6f70310f54"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0ef36780d1651035802180c072fb8835d9745b8971b1f3bb7b365b1d3395f7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b70c03c995abc005455ebad5630e014cf1ca72a74d0f8afd6c27828872df7d27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "261984ebc5c6a4a4fe3785507fbf6bd4a334a052be59039f00bba8f23df881b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "94e4d3b415741449e3be5086a9df3b0bcfd34a7d492b691fc9dbaf44cfb251f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efd3176b6b5eb264a9f1c1fa0e4995b800d0f61514c248aabd8fa030a1eee347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "129813ab598a5d78bb2f997e69512f9a9231d0d016a1160f3c1dfa4c7ef2ce59"
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
