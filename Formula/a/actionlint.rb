class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "fd5193e1724062dbc086af4478a3c28492585266a9ff6fa134c3751eb38bc4ef"
  license "MIT"
  head "https://github.com/rhysd/actionlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75219d9c47da85d840bda6086e9e86411b02c8862665eb0e459316e492a92eda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75219d9c47da85d840bda6086e9e86411b02c8862665eb0e459316e492a92eda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75219d9c47da85d840bda6086e9e86411b02c8862665eb0e459316e492a92eda"
    sha256 cellar: :any_skip_relocation, sonoma:        "db12e88eee7462a461cbdb5edcec18115b27351f04dcd545c23092dabfa91020"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29b52c84728e9a5a0b2eff3605b926a4b162cea55a8517872109378af4d83192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f81ede93b1282028ddae2dda72a4241777e34bfbbee039d52cb7067de63cfd"
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
