class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "557a82924dabad35faec3c649a18ec09130220f58610e9a925f5e33da6a9f2b1"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c54f1b6682fb962aa1b1c1defabb3b684802383bee51be92741434ac2e6a036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c54f1b6682fb962aa1b1c1defabb3b684802383bee51be92741434ac2e6a036"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c54f1b6682fb962aa1b1c1defabb3b684802383bee51be92741434ac2e6a036"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2e2d75d739894c5fdfdafbcaa645fbacbe3adac1acf64e29304cb0917770f77"
    sha256 cellar: :any_skip_relocation, ventura:       "b2e2d75d739894c5fdfdafbcaa645fbacbe3adac1acf64e29304cb0917770f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fe3c25d9ee93cee16fd7b190498682542f21e4015e9deb9000cf1feb014fe3e"
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
