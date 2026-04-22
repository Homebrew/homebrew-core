class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "b83ca9cd6009aaf7fdffd96d9ce40ef307ddae6bca9571afba12c3f760dc2e0f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16900bacfa823d4fe0262afebe95e45d5a4998c88044ed6fc959f51f09198704"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2180c26c01d77f92b1e5a8028a149a0b861f51c822b139810606759d05c53183"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e40d44f4c4cd23394cb85d92314b6cc44bb18df6dc23488c5efb9a6c3d147c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "790475b9bba17155719f19a029becc5b70a2236b52996848ca753b441927fe78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05d71c7e170f1ecae3bebab03f494a7953f1da6a252fc9f798a01b78bcd91509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7612e640733145f7304d366b2ba58182c87768e840798a6aa476bfdd90c1ff8f"
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
