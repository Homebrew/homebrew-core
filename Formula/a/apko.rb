class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "daac21e1ee92dbc83881382e4a375bbeb3550fcf17e5a76a7f7c7cb03408cd6b"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e454c909e27778193c21f745c8f166255cde8b5eb55639fe1e0e5641fbb7cf38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e454c909e27778193c21f745c8f166255cde8b5eb55639fe1e0e5641fbb7cf38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e454c909e27778193c21f745c8f166255cde8b5eb55639fe1e0e5641fbb7cf38"
    sha256 cellar: :any_skip_relocation, ventura:        "6634cc885579291a0cb59570f64dee22855b9cae58d926427afea6b8e1b3786e"
    sha256 cellar: :any_skip_relocation, monterey:       "6634cc885579291a0cb59570f64dee22855b9cae58d926427afea6b8e1b3786e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6634cc885579291a0cb59570f64dee22855b9cae58d926427afea6b8e1b3786e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2591a206e97cc8da2a2a440463636fc3ba902d31e6d6706306a88005b96754b"
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
