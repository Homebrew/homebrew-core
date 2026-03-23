class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.16.tar.gz"
  sha256 "1058979800a331b8a15335d6a1affd5a759431a510d0f69b7978ae7029766a7a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93ebffe77794fb636ef88358465b8d600e03ae6ac4ef0f11243405dd89b7abd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02d42d1724fab500881d090b48d2c56b924b486aa0b6c280d5610c354fb215c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55eb097c35066be83e5eb35d9fd35b0cb8666322d9ace0bf9acc558fc542d532"
    sha256 cellar: :any_skip_relocation, sonoma:        "5224a594fa46b229907d9e66ed26278ca315881cf38dcb9b410f3aaa8858db01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52a0cf3f159523bbe26b3de56894cfe2c60b20bc3be0a3731f7f700cc94832bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a7ed2679931d59fdfd0b5cd3c4babbecdf2bb7132029f89f485bf2bead56c6"
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
