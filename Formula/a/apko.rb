class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.22.7.tar.gz"
  sha256 "db5ab508444f25f92e1771d2e8748b84b3ef7444da124acfbbcca96732ddbb3c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4674c4678e55f11754937cf6d3b1f22c0a32a99998366698d0c1c8c0861712f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4674c4678e55f11754937cf6d3b1f22c0a32a99998366698d0c1c8c0861712f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4674c4678e55f11754937cf6d3b1f22c0a32a99998366698d0c1c8c0861712f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6398152053fb30b749f67fd1dd436a9b8816bd3aa94f847f1507c0cd00e7aa24"
    sha256 cellar: :any_skip_relocation, ventura:       "6398152053fb30b749f67fd1dd436a9b8816bd3aa94f847f1507c0cd00e7aa24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "715fe21fda68f910a2e6c776a736fb59dc3ff1cdbae360af72072a705e77659a"
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
    assert_predicate testpath/"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
