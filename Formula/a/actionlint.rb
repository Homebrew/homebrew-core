class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "f53808c46db1ac2aa579b00f4a12a8acdf6eaf85a382091ce051dea33b18d7b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c0c108779f28976420fccc0628a80b47abbce66a10292ffcc55bdc6750c2666"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c0c108779f28976420fccc0628a80b47abbce66a10292ffcc55bdc6750c2666"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c0c108779f28976420fccc0628a80b47abbce66a10292ffcc55bdc6750c2666"
    sha256 cellar: :any_skip_relocation, sonoma:         "0524b6fe37c904c06ded09f171d6a71323a1ed3c568658f2fac65a64c2fa9954"
    sha256 cellar: :any_skip_relocation, ventura:        "0524b6fe37c904c06ded09f171d6a71323a1ed3c568658f2fac65a64c2fa9954"
    sha256 cellar: :any_skip_relocation, monterey:       "0524b6fe37c904c06ded09f171d6a71323a1ed3c568658f2fac65a64c2fa9954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2d56dfd91f6e3f4a50705e5040a9350744cf1e16d26ff8afb4261f9598e56f5"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    ldflags = "-s -w -X github.com/rhysd/actionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    (testpath/"action.yaml").write <<~YAML
      name: Test
      on: push
      jobs:
        test:
          permissions:
            attestations: write
          steps:
            - run: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/actionlint #{testpath}/action.yaml", 1)
    assert_match "\"runs-on\" section is missing in job", output
    refute_match "unknown permission scope", output
  end
end
