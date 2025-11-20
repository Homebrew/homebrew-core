class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "1c1e058ed2202e342f474c6ec1a18164cd60473f61163b78a6afb5aff4fac4bc"
  license "MIT"
  head "https://github.com/rhysd/actionlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "078ed93bed877dcd668a869e8ab2e17f911477dec9ec5c450942111f39592d60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "078ed93bed877dcd668a869e8ab2e17f911477dec9ec5c450942111f39592d60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "078ed93bed877dcd668a869e8ab2e17f911477dec9ec5c450942111f39592d60"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5e49fed60a5539e4583579d4bb627a616c6f03523704a7f8b8186e49a384c4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f29d4e5e5c3149db1655520d05d87b5218d2aea944b4010b3ce84675c1f2e841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50813a23bfd071e6458fd453c6585a3b979289eb321cb538e7a4e3ef29c16b0"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "shellcheck"

  def install
    ldflags = "-s -w -X github.com/rhysd/actionlint.version=#{version}"
    # FIXME: we shouldn't need this, but patchelf.rb does not seem to work well with the layout of Aarch64 ELF files
    ldflags += " -extld #{ENV.cc}" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags:), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actionlint --version 2>&1")

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
