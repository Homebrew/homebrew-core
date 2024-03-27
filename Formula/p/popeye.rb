class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "9f8f5b46a942ec7fcaf777ec7f16e6d64317cfdc7080e3d637018d778656ee94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78629cedf2f78b50dc5e91b5ba69c712669c056874863fbd752479ae5a87d993"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e57cbfb00315df230e23f429d7d639c49ce23423d49de34c01f22f1c4541f63e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f1fdadebe8051d0357f31f8df659e1dae02aef633596cd9759a53c0bffb3ac5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8435b06f4132549dd5599f1165105c324b18fcbcaa8236cd40171a18716d30da"
    sha256 cellar: :any_skip_relocation, ventura:        "0c836443b217e7c182c01379de0c2bb97c96fa6162508014e3e5c053d8e618a7"
    sha256 cellar: :any_skip_relocation, monterey:       "867e2cfd37cec65060f9822d431ce3c69f220d772e498afb5e79577ccc73d71a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "261e692f5f76f5d6ee59c81a04cc2f76e00944dae4bd6139ce59b350bbc69ac8"
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
