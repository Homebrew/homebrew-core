class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.14.7.tar.gz"
  sha256 "2615f3844cb180db4a346f526dbb2385ef2eae3c2b74b49e40fb71d2b11d0496"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec0b33258fcd6ea9901c25932f9fe09bbe2824a1258e77b056f0c788fd7ab053"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37a686d92b833950fa9ed0b5bbb8e03373ff305af777b2093907c1759b44bdda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13304d996f28b84c59e1bb7f4e5d5ea8ae61bd82eeff9d7d00417e3eff93054f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5342935d4d21e32ab37b42fb4d7645470c95da0bb91aa75e2399c737e5ee6ce5"
    sha256 cellar: :any_skip_relocation, ventura:        "b6982d848138bb78540c9cd97e238ac3cb595c7a54a9d1fe1d162496f5f6284c"
    sha256 cellar: :any_skip_relocation, monterey:       "58b192edf4e1b25c6a3929c2d347bc5be3a616b6a48750b1d6d21a11b174462d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "460bbe36f0949a9b56fc43611eac90d8ef26b88a660255078e52bb6c727ffaec"
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
