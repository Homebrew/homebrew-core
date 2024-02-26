class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "4216984867e6c2c0a5576d75f82cb3c7c51766ac7d1dbc01dffd71abddcbdaf4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e807bc9bc9dcfecce25e35d0a84e47ac15aafa76fc733d576d1e57b29bb4ffd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ceb8718bf8e12a73c7fe27e377d5cd987e90e454e6979b955ca61164de68ee0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eee4b37da05c1b8104ee733ebf74c359c05d82534b87dafe6540c1e4227f1a34"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b3af61ffaa955fe7ce60319bfad291cbd662176f77b6902f8b1efe578d2423e"
    sha256 cellar: :any_skip_relocation, ventura:        "98f56a2086c9ba95254af9103ddaf62f3fc651d7ac6d7c7130269ecafa7ff524"
    sha256 cellar: :any_skip_relocation, monterey:       "94848ce34c8341791b8d0cd945cc343a2bae978d3c49675c1db6e14f74054b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "008e7debce04fb627313d56cb1ced450e393c3e7032e5059964eaa03c12405b1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/popeye/cmd.version=#{version}
      -X github.com/derailed/popeye/cmd.commit=#{tap.user}
      -X github.com/derailed/popeye/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    output = shell_output("#{bin}/popeye --save --out html --output-file report.html 2>&1", 2)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/popeye version")
  end
end
