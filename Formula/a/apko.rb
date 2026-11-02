class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.15.tar.gz"
  sha256 "1353da965103d326c79b0e6dd5c9b6f359a831fc66357e9bf01cd9bb182fb7c2"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae0cb3efeb526cda6b29888e3b3968e6cba4709404206876649f147a9550437f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d454d88fc13d06986145c20250cff076240ab9cd7ccde858fb50b39ae6f1693"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6875fb3b8f188e70bd5896ff7532c1372a1bcfdbfb3768ec6d32afd5a5f4b5d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d79aed115d25fd084457422506a7d7e7c818f84b1fe1ae4c275fa316d64ebb7d"
    sha256 cellar: :any,                 x86_64_linux:      "175e02e0d3717c5b2451b9a0fccd4adf5ba438c24154cdd69c607b05ece3ab15"
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
