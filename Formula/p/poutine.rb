class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "91fd5c703e27385809fc40deb49af3b3de2feda47bf1f75fb6c1065602a880a8"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0afa5f904991ba614cf1db698ce0c04183c6344a7c3ce11c4b8b8314f9ba10cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f8374f4d3d0d5959c8517717d27258eef38cc94c85eff7442893ff6818fb0a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d35839002da6d0a56c792bc9ea5e52f4b1eaba6ed745778403e4dcefeabcac"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dc49d0cc8d30e052e274a1256eb5290fc86075cfec2ee2404ffb67178e0797d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2a0eeb8d9a18a3c114cb36aa373bb31f469cc4bf80cd514710c56ae9c708fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48c55c8e40e28044455775e8dc4ac9a3207dd2a11ea791483a3a0e8548fafc18"
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
