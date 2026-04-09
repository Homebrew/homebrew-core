class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "48bad7bd296ec32fb8620f235a13167436f3921769c5b735c30757b6f118d345"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05f10ac70f51bf9dd0a4db4bd44c47698eebfb069944bebb860b1a65d3fc6b94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5eb7bc09597b6aed72244fa05b4903c6fd58ca509cd251b70551be6ca70961b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1adc2d0e9d434b2f64a3005bd48a4008b69566b81d945136e5595421bf352f68"
    sha256 cellar: :any_skip_relocation, sonoma:        "57f6702006b26f0b656fe3235a3074c5b4844459704e42e0983f0173d230be47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22ed16af3b37aa754b7ce0ebe2e6d953bc6194cb958c9df78d93928b4f3efd70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab872214a574b18cafbc4983872e8c493a024f5bd5c9b93d4f379321dbdccdb"
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
