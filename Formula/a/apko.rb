class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "63449084f0556abb4d0796e5aec73710a082db1feab782b1b9126cb32478606c"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24d2726a577f9bc7cab218064a6c9319dae5bde9c9fd17471f499fbede78166f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13512683596774b7e232298b76eb1d190a055740801a998bee1c621f8ae7425a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b14a2276b94293c2de997dd91c1d459f72863b3561d0e4c33f5e5611ee6d8bff"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab0ecd6d8acdfac3e577e7b1eff609c008cf806e4bd5b179b4d42fc7bdcaaef9"
    sha256 cellar: :any_skip_relocation, ventura:        "f30b741c81f5fe7bfe14305bf454e35773dc6c10f717acb514546744b68f9513"
    sha256 cellar: :any_skip_relocation, monterey:       "10440bf0ec1eedf3a401ec770fc1fbcfd2ba5dddbef8ed8a3c3db5007fe37b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaa57c9a19a4fd1fbf4e49d9c6c50bc23053d5656a13059abe3e35c4aeaad450"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

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
