class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https://amrdeveloper.github.io/GQL/"
  url "https://github.com/AmrDeveloper/GQL/archive/refs/tags/0.37.0.tar.gz"
  sha256 "56cd23d5d8236c0e103195cdf284b773844eccd8f3caa0b6b7b473df1503baea"
  license "MIT"
  head "https://github.com/AmrDeveloper/GQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90f2c8ffc7d36eaf22cc442045428f59e47234277162aae07ba975bf9ddc1802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f582bbd42c0d5cfd49982581f43c4cf28bd8cf6a81d8b91eecbcd7ed64c433e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d136ead59c7e6a5ff5e87e9a2aa0df9badbab9a6cb3e43be843a11d01da52d2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "71068d471ed38f63c0038accf17734c02c737c70de501aad3edbc1034a1a9338"
    sha256 cellar: :any_skip_relocation, ventura:       "b0130e6d00ae6db3aa7032b1b841fc9a7beae6d3ad1709c7f54caeb9f17bc58b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39480d7964da01f500cdb47fe75f13380e1e787fd42289d20391828d8c049d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88307577f7da841ef7432ba83def7d627d423d6fb909bb20630c17c00636b1b4"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  conflicts_with "gitql", because: "both install `gitql` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    output = JSON.parse(shell_output("#{bin}/gitql -o json -q 'SELECT 1 + 1 LIMIT 1'"))
    assert_equal "2", output.first["column_0"]
  end
end
