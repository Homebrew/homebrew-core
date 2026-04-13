class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.13.11.tar.gz"
  sha256 "d4161413104291aa88c094863aacf2dd1c97cbb5325a56b8fc92e6448cd65a86"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f524bfd04eec3c9dad9cbe545ded3902d893448a3de9bcbbde45abfb88e91e23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd91bbd04fd724b433093437e4e310f2fcab54ee8f48cfc8264c40af68ae3639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c967c97d0ef9dd9c751357c56b2c3fa47ace3f6b60f77c213a07b66b3dc763d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5125a39d69c45663e83492bfacfc6b859687b5265efd9c7e5b2da8542b3cb777"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1aeef2b550e240e4df5b60d5032ecb3354f4e627727f653060dc81275d8eeeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "365d6dc0e193eebd5696d52310c163553fe85d060a14b45d51594f293ef8ecd9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")

    generate_completions_from_executable(bin/"prqlc", "shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prqlc --version")

    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
