class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.24.tar.gz"
  sha256 "0dc8b31c8541a719486b5678e6f0401c8c13ce7baf79013570f3799f380c1dc1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5658fd0db5c992ad3240708cdb96773665896c83b10be9fd719d1caea07e428"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5658fd0db5c992ad3240708cdb96773665896c83b10be9fd719d1caea07e428"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5658fd0db5c992ad3240708cdb96773665896c83b10be9fd719d1caea07e428"
    sha256 cellar: :any_skip_relocation, ventura:        "0bed00383fb6d62acf89694b979708c7474ffcd943f7449cea90998ab04da948"
    sha256 cellar: :any_skip_relocation, monterey:       "0bed00383fb6d62acf89694b979708c7474ffcd943f7449cea90998ab04da948"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bed00383fb6d62acf89694b979708c7474ffcd943f7449cea90998ab04da948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3212d105058cdcbd0beb8b5ccdfb5361fcc53b6c12c226b94c867b09821c5473"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/rhysd/actionlint.version=#{version}"), "./cmd/actionlint"
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

    assert_match "\"runs-on\" section is missing in job", shell_output(bin/"actionlint #{testpath}/action.yaml", 1)
  end
end
