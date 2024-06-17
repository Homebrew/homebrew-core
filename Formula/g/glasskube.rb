class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "d7f66df6e2a2386d1b9ee740a38c6e75b4cc6e35db08b361ea20359408cb2890"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a00feec38c3fa2a54f3591cdc0a69e653c154bd9d46f480626fcf2fab94be2db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8913353caa2064fea563bacf4e21ea9edaccdd51f173517e9d1381123352c4d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52a7990da5fcef65d201bec1ddee77f9f2526a2e07df9429c11b4e87d2c074fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "eccfe87bfb5a5a0418946353967c1ce895d59c634d97303b80ca9b434fcbaece"
    sha256 cellar: :any_skip_relocation, ventura:        "07a657b9632185f5a1734256e647d652b4b676b6a336fd005296981c8fd485ec"
    sha256 cellar: :any_skip_relocation, monterey:       "709cffd3033d8606d4b6b42c0f0fcb5d4642641f358b8b60fdb1fdabc92cb96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af35a62d7b96215deb332443c0cd55b2ee218dca9e423ed1ba993d80822bc557"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/glasskube/glasskube/internal/config.Version=#{version}
      -X github.com/glasskube/glasskube/internal/config.Commit=#{tap.user}
      -X github.com/glasskube/glasskube/internal/config.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), "./cmd/glasskube"

    generate_completions_from_executable(bin/"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}/glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}/glasskube --version")
  end
end
