class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "6a37f8ebbd7aaf59a2e716989fae02274630d6b5b6d9b412ad0e62eb7120a7c2"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b64630976f9250659df867f0c4a69fd7f6e51651ba9c483acc3476bb80c3d0ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b64630976f9250659df867f0c4a69fd7f6e51651ba9c483acc3476bb80c3d0ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b64630976f9250659df867f0c4a69fd7f6e51651ba9c483acc3476bb80c3d0ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd2b05d18e2773d0a857afb7995aadb0b07e0da65685ebd84f30d2a1d7ae4469"
    sha256 cellar: :any_skip_relocation, ventura:       "fd2b05d18e2773d0a857afb7995aadb0b07e0da65685ebd84f30d2a1d7ae4469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72832cd96791f7b3db2b03921061c774a4d6b1f3fd40765a2e7c4f016d49090e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"poutine", "completion")
  end

  test do
    mkdir testpath/".poutine"
    (testpath/".poutine.yml").write <<~YAML
      include:
      - path: .poutine
      ignoreForks: true
    YAML

    assert_match version.to_s, shell_output("#{bin}/poutine version")

    # Creating local Git repo with vulnerable test file that the scanner can detect
    # This makes no outbound network call and does not read or write outside the of the temp directory
    (testpath/"repo/.github/workflows/").mkpath
    system "git", "-C", testpath/"repo", "init"
    system "git", "-C", testpath/"repo", "remote", "add", "origin", "git@github.com:actions/whatever.git"
    (testpath/"repo/.github/workflows/build.yml").write <<~YAML
      on:
        pull_request_target:
      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
          - uses: actions/checkout@v3
            with:
              ref: ${{ github.event.pull_request.head.sha }}
          - run: make test
    YAML
    system "git", "-C", testpath/"repo", "add", ".github/workflows/build.yml"
    system "git", "-C", testpath/"repo", "commit", "-m", "message"
    assert_match "Detected usage of `make`", shell_output("#{bin}/poutine analyze_local #{testpath}/repo")
  end
end
