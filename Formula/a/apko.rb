class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.23.tar.gz"
  sha256 "edebee2c6580cdbc13839bd9f283d0aa9dceaae2eed72ba60443fddd124d4c4f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74f19ca86cd59065b9a8ee7e89e9674a2004c20b1aac33dd0910c83a793dae88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d675877f89688123b2b4fd23019f2276a44588c0ccb2deec9d65a55723db379a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4adea032667133d25535e012a440717750c9ac847529d443d87a2804028a42d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "79d4db49f8df5c532da1486741c685e42b38e9a3c8c8d1c6b5d9a28e309a4902"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e838e7e56190608517d396fa9ccba59eca02a0c869f556b847afaf083b6f760"
    sha256 cellar: :any,                 x86_64_linux:  "3867b08065da262bd7c5a25b7f2fa42d3059740804f744139e30ea5d90a24af5"
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
