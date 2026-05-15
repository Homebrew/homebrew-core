class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "adebd06fbddbdc9fc6dc858cfbce132a3221d880775c4a1102559394c3127f88"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f69bde9468c768b028294d175ef4779c027df82e063fc5f484efda525af0898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f69bde9468c768b028294d175ef4779c027df82e063fc5f484efda525af0898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f69bde9468c768b028294d175ef4779c027df82e063fc5f484efda525af0898"
    sha256 cellar: :any_skip_relocation, sonoma:        "8167304a003dc86f2568f5fb529b0f1bd403cc12d05caef9bf3bd76e2a5d6fd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84e047e2e28e878c79c31dd6002d72e2236d97ae5d804514169777f381d96df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cad95be560f3eafbb425345eb5a52f1fc492de62228fd2b4dbd36103e8305099"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinact --version")

    (testpath/"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    system bin/"pinact", "run", "action.yml"

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, (testpath/"action.yml").read)
  end
end
