class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.26.tar.gz"
  sha256 "507d771f4c863bf98dfe1db3500a4c9344e3a35592a6e2ac4183f00a63291feb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e0cab19fa67d738590ffe512a239d85e99503f5148def7966edcf8db8227185"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e0cab19fa67d738590ffe512a239d85e99503f5148def7966edcf8db8227185"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e0cab19fa67d738590ffe512a239d85e99503f5148def7966edcf8db8227185"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e0cab19fa67d738590ffe512a239d85e99503f5148def7966edcf8db8227185"
    sha256 cellar: :any_skip_relocation, sonoma:         "4107ff822a57874bce9572a9e8a089fe89fb933aa637e13bfef2dc64fc0b1ba2"
    sha256 cellar: :any_skip_relocation, ventura:        "4107ff822a57874bce9572a9e8a089fe89fb933aa637e13bfef2dc64fc0b1ba2"
    sha256 cellar: :any_skip_relocation, monterey:       "4107ff822a57874bce9572a9e8a089fe89fb933aa637e13bfef2dc64fc0b1ba2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4107ff822a57874bce9572a9e8a089fe89fb933aa637e13bfef2dc64fc0b1ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "968c55465554d2b300b5a88051a9c63361c352aa2ca4809ac9e209eae2133ad3"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    ldflags = "-s -w -X github.com/rhysd/actionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    (testpath/"action.yaml").write <<~EOS
      name: Test
      on: push
      jobs:
        test:
          steps:
            - run: actions/checkout@v2
    EOS

    assert_match "\"runs-on\" section is missing in job", shell_output("#{bin}/actionlint #{testpath}/action.yaml", 1)
  end
end
