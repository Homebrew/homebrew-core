class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "1b4bd3e4fe5cb8922cdd1090fb186ec733e27b53c2d3d89abaed0c029bc62a11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f2f8ef4802aeca92d9c9be3885f214bda0ee532423d84841207420ac9eeb209"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c198fe4076c13f1e3a80c12da9345bd7f8b4763589f60796f4a122d5c7e6ddb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e34dcfe809282d84ab8cdf59083660c990bf6e3bb5ed54b999851100a43f522a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a7b8850a68f8fa3f1e025dd615336e5cd7f964f10c2d7b7a94947e0b85d9cfd"
    sha256 cellar: :any_skip_relocation, ventura:        "bbaa946606ff2e5d48e2088493a0c1a28df7d695bb7f150527428c955aff7d12"
    sha256 cellar: :any_skip_relocation, monterey:       "404ecf8f034419e5f2913844b5ca4807db11b35bb0b926516653c42acfddc516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cb6856e27992163e7e20313029bf4ed5da401704d5e998b8fa110f5d5747758"
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
