class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "63191da77140d4bc30d8c231139febecf6a165a84ab7822b8216e2598064158f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "775b56123f36d3d4fc7b6a548cdbc9de0a5813f0e9fc4fc5deac4a204eec2d7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a513dbcbb38ec74beed3707c7f58ae8bcd72e7a4e7e3dbe89de5a5f22607243"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76c78421aca08bc565b69882ba1c31e97c27352b825e059a89d309949e1cae2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "db665f46a566451866448e46dec17509a375ed03d6039ef0b0b434ca7863f60f"
    sha256 cellar: :any_skip_relocation, ventura:        "056eec1e8256fed48bc7a031ccaabdd6573135fa9cd37f0d633e9a958170661f"
    sha256 cellar: :any_skip_relocation, monterey:       "610a72bb92806abd1cadf34ee56077646fb054a9bd86f2cc6894b958da83592d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fba445a5e374adf84d427bfb95e5979ae7855c406ebb0ff2c5eba7a8e830e63"
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
    (testpath/"test.yml").write <<~EOS
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
    EOS
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath/"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
