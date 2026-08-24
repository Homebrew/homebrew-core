class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/2.2.1.tar.gz"
  sha256 "06882bd8906ed41c1616a6a2d2705ab14e61b430caf8e064f04d5a3c8c9f9ae1"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf30a6626b032f62cc41a836fdd069b6c349841a4d9b9d1821b6b963c986023d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf30a6626b032f62cc41a836fdd069b6c349841a4d9b9d1821b6b963c986023d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf30a6626b032f62cc41a836fdd069b6c349841a4d9b9d1821b6b963c986023d"
    sha256 cellar: :any_skip_relocation, sonoma:        "06a72561ae742b406eed0b1631883731843a6acb4336f95aeaf9f87abddd8a53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26e745088e81704c552f51b24341bcf600f1cbda9d274f2e1355920763f3c965"
    sha256 cellar: :any,                 x86_64_linux:  "b6b51ad745042bf9d7c3b4b227f5be9cdae20b0e9dbf43cb2a6481ceec9b0905"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/massdriver-cloud/mass/internal/version.version=#{version}
      -X github.com/massdriver-cloud/mass/internal/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
