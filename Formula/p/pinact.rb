class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.4.5.tar.gz"
  sha256 "e2e3d1365766925544102e765aa7468ed8987cf685eee8c3120a9e5ef82e532e"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78412d371aeb0c57c9b6920dff49c8456d4523068248926cfd50d5e067a17d69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78412d371aeb0c57c9b6920dff49c8456d4523068248926cfd50d5e067a17d69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78412d371aeb0c57c9b6920dff49c8456d4523068248926cfd50d5e067a17d69"
    sha256 cellar: :any_skip_relocation, sonoma:        "29803faa386908eb42cd189bce795f6650e002173439de429179cb4f2362cee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a14e31119a8d5db394295d2ab4567e89d08c666ac4e4755430ed68211b1ef082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d56af8e85fc620ad614f9fad79a9b2bf8e01a1e851170717b6ece2d2b45f5f9e"
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
