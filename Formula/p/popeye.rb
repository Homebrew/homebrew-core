class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.20.5.tar.gz"
  sha256 "65bd1d1cc13e48ec44c9be0c45d514fbc06e39ec6b38ebce18f07988a329317c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e621781c69aad86ef1e046b36e6211f281e6eaef8261341ba297c84a8fb9ddbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c6d271d771cecd8761498acfd72a7903a419e75bbea80e98944268b32f0915b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05a2c711a63dc2d7ed77a3b902a7ba81ecac7aba082e9d13668bf4c625a93f2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6e7374073a47c49226338e2b9382da601b613d409206c5e7cfa8dc2c4219c67"
    sha256 cellar: :any_skip_relocation, ventura:        "ae3a91f3f84774c919cdcd9237a74977656a59b26cf13a3bc03bc44c87d14c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "a587a241347cf0cd4441bafb3c95816555853fd84b5b5cf49a7347cfb97cfca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b166793dad008555ea25178184c246b88d80e142478d084ed5458e7a974bc6c"
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
    output = shell_output("#{bin}/popeye --save --out html --output-file report.html 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/popeye version")
  end
end
