class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.18.tar.gz"
  sha256 "f1619106590be6cc493141083200894dda1f8f25d00ffba1e7afc55e98c0534b"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "194aec1af7c4df272032198c91a963abfc7b283b6897854f34fe43a9c4912867"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f51cde3b2493a529ddfff4df398ae1ee96c4a655816f1bc0817f564c9339d415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dedc880f9e1cb0ed16745f5cf7ee939c54419e29d7fc090cde771b0bdb2f6bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a5b889c6c3260e7868acaebe6469abb3bbdd7a4616d557ee41bbff7b14eea7e1"
    sha256 cellar: :any,                 x86_64_linux:      "ddcaf9609f48e681c1517bba65b040c6c9551466a1861ca0dc745b720a362bcc"
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
