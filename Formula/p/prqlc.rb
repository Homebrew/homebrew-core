class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.13.10.tar.gz"
  sha256 "ca618ce52bbec3de60b5bf8193c4c0f208b7681374575b809e4f1604867dba47"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcb91072733b283682b4c9d3dca802ecec5ad33935f54092184d2c496e3ba3c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a342aa3ae3364743dd5ca259dfe7e59a89a94e6e92a79bf0a32e7d7504a3821c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d3b5b71aabc6d888bd4b46ed35cb40a3e798a002b24c24d6394750b99f8d002"
    sha256 cellar: :any_skip_relocation, sonoma:        "17c8d48e115b06614e4e417a4d2b8635f08fde0544ad663703c7faeeb881a7db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25e37b1562abe783c7c255f61eed8530f74f0d75fb8a5710110ccd3f6494eaba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cf210eb5b1b31dcad620de55f4247bd6b149a5c79b84507b88d55eb9cb0371c"
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
