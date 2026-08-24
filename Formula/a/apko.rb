class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.40.tar.gz"
  sha256 "1e1674aa83dbfdfbe7ba72cf803a183962a2a8d9ac0a99eb0c1659f8bf8d474e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "684b82d1be136a5c014e34351decca0399fff9e2ce87ff5b584fe7b38076bdb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e5762bf46b67063e5a3aa1c1cc173fa0c4de4c7a3513996bd2ff8b883f1f9c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38450ad8435cf4e4087e8505fd069330da22baf81cdf00b55a4fd71d672ff6d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a01aeddc8d39e35302f53e55d43f8c8c0b0294d1f118fdc554371f9847aff79e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea4b3bc05b6d1e56f34a2660d3c51c10951e6842149371917bfba106dad4776a"
    sha256 cellar: :any,                 x86_64_linux:  "4a442c76329841860abe5aac6ce2f634ec57d907a28c11f4f38ebaad8bc3c733"
  end

  depends_on "go" => :build

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
