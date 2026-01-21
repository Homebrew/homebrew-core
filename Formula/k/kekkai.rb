class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "b88fd2d97d8fbc24168b51d1ea621a142ed5a5563919f66bcf6698234f568395"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b5bc6242bbf1f894311483897e946c157ed6fc7d89f4a1a57369d30bcb9fed4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b5bc6242bbf1f894311483897e946c157ed6fc7d89f4a1a57369d30bcb9fed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b5bc6242bbf1f894311483897e946c157ed6fc7d89f4a1a57369d30bcb9fed4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5758ca13ad929bb2bbf36143d1fedfa47408a80731bd273aa30ef493e12108ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecebe63ed091dfdf7d7876c4a21ab04c690ef4c6afa6ff435ecb376e2818e1a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ba7f5a22b9e0928a8c7eeaf08e90dda6eebb355ef78159bc40809e29d2df7a4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end
