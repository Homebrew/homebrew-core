class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.11.1.tar.gz"
  sha256 "98c8509dfb216e35f6e51a7a79c2fd59b3fe603d74242914a19a796f2b9c9bd0"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59418ed02aa3380fc50ec992b14fe41e29a29175c159d12e7402203c3ba00adb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e5bf9df2ca0ef14501438564fc4cbe2ac9fde8f010e89111e88b042792c4c8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77851b8e8ef2a83cb805698e5b1ba352d26f85506093d37659c554d5e4bc279f"
    sha256 cellar: :any_skip_relocation, sonoma:         "62802b73506979bc248784d155cf02e1fc5de8d3dd598645f6f69f2706a27014"
    sha256 cellar: :any_skip_relocation, ventura:        "d7818e18524b24d877268541e1b0e33c7a66e36c3d136c7560e5078783bb4e4e"
    sha256 cellar: :any_skip_relocation, monterey:       "7a78c1f9f225a76a086f3ceb3691a8f383b762eef887814c9e02bb2295e3e420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d77fd0f3a60e16e9642d963b739d432a34541ca5cff54bc0c415c4d3148c0e0c"
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
