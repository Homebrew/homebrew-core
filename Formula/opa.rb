class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.46.1.tar.gz"
  sha256 "5e2cfdff17877d42d4c68a6aae925a131f12b4d45d74a17c4a81a0d9383ee997"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "966509891800adcdf588d52ea497cfae40432e9cc1838f42a2780b90447bd506"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cdd115bccb3b5f8f011aa60a3582169aad2dc38363d1c0c9034aa1e88817cb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7300f9bf6fd309f16a4bdb0f82fa0c2a9400eeb31f7ca7ff67cc94c4cc1badda"
    sha256 cellar: :any_skip_relocation, ventura:        "cddee24d323448c37aa6b1c67c4ec5df2358fa845a1865a74fc61c5fa736f5b0"
    sha256 cellar: :any_skip_relocation, monterey:       "af29fb92919efec7c6637759aba9a833b9bb20405a2f4750a72d9ce2aa31a082"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f8acc4f7e8dea737069b7c9aff41d7d7f91f514d1ba19e560eae4ea152217d1"
    sha256 cellar: :any_skip_relocation, catalina:       "edd79de8597308df01643b10efd44e7f3809fa80a507d47a48c951cd3ff1b942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93dbf152e742dd6752f8e1cc33b07276c545c9e43f94e0f563259f334ec57d0b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
