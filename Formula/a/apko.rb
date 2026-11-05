class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.17.tar.gz"
  sha256 "0719c9eecb189dc7c22cd61852091ec44329c31a16750ed575d560c79f356ada"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66c50fd63fd36501382d8aa5555e0c18112b44116c97ed87c6632fa7eef7a7eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b0ada668be286ccb6736402c19ecadd3e93660e66b11acfc69cbe2cccb9bcb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8055828be698607b44c9f8896d7f79a4b257a1b547749d458ac5fc271b2d7ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2a6487fc82b0b10cf7797bae64d0ddbffedef5c3831dccb915dc79ead62927dc"
    sha256 cellar: :any,                 x86_64_linux:      "06848cb47b363898650fbf4912ab62ad4a1b841a72b8d0df6c4bc587953a6bf1"
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
