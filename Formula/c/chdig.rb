class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v26.8.1.tar.gz"
  sha256 "4d5310d91f9e65132d74db14cd5d5fe2b08f212807d4eb89c427a81b9c7bfc1b"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7e580a8dd1e561e97363151dbf8cc07b5df884c2eab72fd9125194bb91a33f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ade6dbe4732bd359c44f7b09d12c66e0b660b7ba9c3da7336730995f6244240d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "986ec42e080e4d598206191096ef7ecc485bc42c80f75b255a2787cf0e63d958"
    sha256 cellar: :any_skip_relocation, sonoma:        "3500b35d882bd7e75955ec88f9f1da346b3107258e94c701a90cdea8c7fb8c5e"
    sha256 cellar: :any,                 arm64_linux:   "a86efd222e19be8b8d4bd0bc40184e1601e8621292263aafc17ea7016ff54a58"
    sha256 cellar: :any,                 x86_64_linux:  "e9c5b83e195828685200fafc4ed818b06ca2fccdc2c58d90df437999bc3eb5d0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
