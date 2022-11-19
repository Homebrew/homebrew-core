class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.22.tar.gz"
  sha256 "96111115dc80569634e6c679950ea5c0df4ae000b12453bc845c4cfa80c4f400"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf287b16a1c8ce29f17645576b7a6c924330873589b297a612671cf380cc6498"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edf9d4092f9c34170ac1c52a0ecc4025355febc28fa22068b2d305ab1accaf8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edf9d4092f9c34170ac1c52a0ecc4025355febc28fa22068b2d305ab1accaf8e"
    sha256 cellar: :any_skip_relocation, ventura:        "c70521304289424f4d1394e52245a0b195934bc08abda9eaffa56d30c3df82b8"
    sha256 cellar: :any_skip_relocation, monterey:       "38be916fb84a9dcabb58bb7f4fe587251d23cc2815b59013377f0db9d3effaaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "38be916fb84a9dcabb58bb7f4fe587251d23cc2815b59013377f0db9d3effaaf"
    sha256 cellar: :any_skip_relocation, catalina:       "38be916fb84a9dcabb58bb7f4fe587251d23cc2815b59013377f0db9d3effaaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3d3bab24fe70cc23fff9372b3a1cc98cf7c69527f1a524e1d09729d36616261"
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
