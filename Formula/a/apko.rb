class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.39.tar.gz"
  sha256 "195e6a5724531fb7261f3790f71397ceda25273a6c100ae63257e6247a20c10c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "366f4a12fb6deb1355c2b25b767e2fd6be048f72df08bfe0470b9bc177cdfc4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "908843da5f124920547a525ab8c57f9ddad060572fc7ff8d85d67553a3924630"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8868d9c68216c4c7f24bedcb98515dc41ff7a33656581b527a8abd4a889e061"
    sha256 cellar: :any_skip_relocation, sonoma:        "339dd6953c3a9be77fd17141d6b1e5ed30359a8f2162929be1439a8fdfcf5041"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "863d4d974c50cae37997ccea930b418778b1e461fa4f8ce0be9d4aa83c840b8c"
    sha256 cellar: :any,                 x86_64_linux:  "fb19eeb7495ac2ffea21ff08ed31d12d3614e889fccee7d14078cf48ca75bc83"
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
