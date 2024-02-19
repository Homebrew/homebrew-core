class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.11.3.tar.gz"
  sha256 "d6bbf5569c9e376d31b0f2e132e510b88cb1d358d736c36d090c76e903f903e3"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22b24a994267bbcbe79ab90e1c4933e61f30fec9d8f5479c25f2dcb2cfc3ed9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8436e711455eeb96ff95a31a3c886f65f6aafdba8547473ca4a1fc84f65b2b2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc67ee966fbdc4e85c0cce745cf70114e6a2652bc39e7a90c9f97ee97f61a517"
    sha256 cellar: :any_skip_relocation, sonoma:         "550838b9dae438391c2c58fa38c0fcf465f6d73ef1a3eee93c99a1d46e6b35ac"
    sha256 cellar: :any_skip_relocation, ventura:        "88eb531af5eb46199755c5ef4742e396d69d5c1ae79ffb30fd431c74d7ad3091"
    sha256 cellar: :any_skip_relocation, monterey:       "12c5b8b938598e8d93b2941d86a75d37ea22e02aa803be237fcce846449958fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82cf2d299e78af06f748a49291e61564ed98f20395803af7211f7f677978ff54"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
