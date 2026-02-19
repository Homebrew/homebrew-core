class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "f8eef3d6b9cda24f4d9bdc24620c1368cd6a749f1321a499e88b339258e01d92"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de4eb07bc059e0cfa41014bce3619f91f6d4cf60cdff0eea2b697dff007fa473"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ceaf3bd7cb2f1566cda40e6cc3531fc1da09a98f9c7799fed9a54fb09529cb24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b5116921f6593e7d94c2ad27ba0ff959958181a13b9890eeef1ca6c6e1998f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b641ed59b339dc31cf366849c8c95c1be2e94df248620b29d4e0e4bf0c1e985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5991ede9c93a0b1036008a8f38df0693a054aac640f08629d0c7f9da44e3b2eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f7675cf16525330166d626f6ab5e83f38cf48026d9baaf9b0333de52055cf37"
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

    generate_completions_from_executable(bin/"popeye", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/popeye --save --out html --output-file report.html 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/popeye version")
  end
end
