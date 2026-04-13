class Dnspyre < Formula
  desc "CLI tool for a high QPS DNS benchmark"
  homepage "https://tantalor93.github.io/dnspyre/"
  url "https://github.com/Tantalor93/dnspyre/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "7ffd73ae045b68c2d0e91f2e2f3c707c85a4618f6948632799725ded7faff680"
  license "MIT"
  head "https://github.com/Tantalor93/dnspyre.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb15fd8e32c9e177b97b3e0be8fa718aab92fc0680ef6d8e97ead1ca58cdd7db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "172a6b5c3596fac0911fa73d326a60b49978408472bada0f4a0a080e77f4f088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eed0ed8dbcb550819c13a0445ccfecb31e84445fdb3467a0e4428c23e8dd6a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "292bc522e5f6cd0e58ad7ca08586b6293fc639e53940d9dc66b916dea967e853"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33747e1aa7f4d87f9726a51a8f222f1ed5803f4ab457d801dda7a59402f1ec9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fafb75512b9461e17be172e640139a9cd79cfe53a01aad6cf3e03f3e6319ada"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tantalor93/dnspyre/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnspyre --version 2>&1")

    output = shell_output("#{bin}/dnspyre example.com")
    assert_match "Using 1 hostnames", output.gsub(/\e\[[0-9;]*m/, "")
  end
end
