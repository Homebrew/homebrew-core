class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.49.2.tar.gz"
  sha256 "7c3d328cdf788a93fd51a756087f88560b154bd80ae4fba268fdebbd22df4fd2"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97710203ee5a86202c0d5d76fb04098b1aa2c0e529ee280beefa1866f4881c0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "161272399741e3e6161f4a9b37884b808c90a4deff27a4708b19b3d1ed35a761"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbc3f983226d83f21727a7a8c027751cbade8bed07a5fded2444d52f9c72714d"
    sha256 cellar: :any_skip_relocation, ventura:        "6384b92059542723a6ddb377f309172d1ae5db8e2f655c507abf578d3fa7e4c9"
    sha256 cellar: :any_skip_relocation, monterey:       "4639e6f991812989594cf1cad73596990507155caca8e82726321ac6d1578810"
    sha256 cellar: :any_skip_relocation, big_sur:        "abe7a31bb9d1e718ca6c0c3f3fd9cb6d1874a9c2f7b726317a3dfaa56f1ae097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d403adb5dab5185ec085145692b1957f23a7a1f55b9d33958309e9ddfe2ecb9"
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
