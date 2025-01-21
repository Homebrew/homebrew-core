class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "e0e01c88efb94f35a71f664267c6c9ab0e22932804e0af864a0a5cd8d348dbca"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46bdef94c160943aba176a886fd1290e82f0052c6a3e9d138a66eda038310429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f220eedcdd45350b0e6700741e656202e8a46a230b5e5ecec61695220ca27a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65057a9f1fcb864b8a87d55a3cb087a9cd202880eb689243a75e5186b48b5123"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1eb8042ec855af1fdc1756993908b0d2827774eaf746bef0cd1aa3bf4feb027"
    sha256 cellar: :any_skip_relocation, ventura:       "03fb519b251f04b4801d08d0aa8d9542cd8cf941a6c484b3561d7ed96a694fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "441b6be5ce0c2dd0cb7f9910c449e124d15e791cc6ac8d6b9989eb6d5c9b410f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
