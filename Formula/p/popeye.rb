class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "f8eef3d6b9cda24f4d9bdc24620c1368cd6a749f1321a499e88b339258e01d92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f2ff1b22e885412cd8c699159328387edc033aea8dc59e3b452832ca22099ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a29f831f909394c8c98753f0ca3cc25dbe30ce7b69c6241b8350376e40736092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32632ae7cda036371ba5a29c5826f07665c9fab00d92f08914ddecb34705c709"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95a5e69a47e586959e8fa11c1ffbd011bcaebbe9b27bb967380812cff73b8ed7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c2b6d822b30777d3fd02b65cd00595c8e6b8642f57468f423c1a998dfaa91be"
    sha256 cellar: :any_skip_relocation, ventura:       "df324d577d9723ecf63f7f9aa6e32c6018b30bc71a0cc505095a8c0a5e54f7f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98c0311e4e966a6b7d956ecac5d5394a577cf22f899337d92eb43faa3872e74b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a29bddbc8b4d01dc7c21663db65b1d22f740f0f33544e89ba900f5a0674dd06"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/popeye/cmd.version=#{version}
      -X github.com/derailed/popeye/cmd.commit=#{tap.user}
      -X github.com/derailed/popeye/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    output = shell_output("#{bin}/popeye --save --out html --output-file report.html 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/popeye version")
  end
end
