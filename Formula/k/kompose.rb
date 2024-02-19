class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "430138393d3109c0aa53091ba136a950f2cf80c5456421afa60a332595093ff3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4be20a10e605173e69c7186d3795357184710c2feff3e6663dd4860fcd372a5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cab12eda7c02ca6fdd47975f53845787f7686ba17be53c46f04043760ae6343f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85a8c0dc37f3446a29542faac143c3b33da3fb7a3be75a64b53e1378fe1d9356"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7f418147889269b8c79e23b0ad297cd24d6099e50f85cded32df4163145b6da"
    sha256 cellar: :any_skip_relocation, ventura:        "288d256a00bfd9511612b5add69c44d2bc009fb007197f6a71237a754c090a32"
    sha256 cellar: :any_skip_relocation, monterey:       "065c5d7c684f81de68351e1ac6503ac55d8f8b03937a4ac2b3cc8b7fdc63613c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd0c97a75a4dccf2c32c3e526364a7d3f5b3e7c204403ddebb67adb164522f5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
