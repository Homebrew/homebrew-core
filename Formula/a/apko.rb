class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.27.9.tar.gz"
  sha256 "8fed1401cf5010edc73aa8d47323fe5d35dcfac573a461e64cf729fadf8afbb4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d27f9d4afafba45fdb243ab0e119cf6d13a5c757eb297deb1ea3880bac38b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d27f9d4afafba45fdb243ab0e119cf6d13a5c757eb297deb1ea3880bac38b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d27f9d4afafba45fdb243ab0e119cf6d13a5c757eb297deb1ea3880bac38b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bb5505819e2fe071d90e509b9e4975cf8dfc6830ab7a079fc402cbb75eb109b"
    sha256 cellar: :any_skip_relocation, ventura:       "2bb5505819e2fe071d90e509b9e4975cf8dfc6830ab7a079fc402cbb75eb109b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c77d0a43f2ca3eef17789e743115061cb4aa3177e53dae31a4ba1e399cb1759"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - alpine-base

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

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
