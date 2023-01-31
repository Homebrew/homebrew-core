class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.202.tar.gz"
  sha256 "96d7f28cc54632062004d831c0e350d02ee8d932bd5deeafc79579605e751ecc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18ff5f280be6764b3eb0a985e42db28f5372e3ceb2f3e279e9a597398681b6d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c51ebfcb59fd73489c0bbf76b9f221db6dd918b4671d47474f0a3ce81a9c3cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e64cf4aa46aef0b340814de36b70947f0a1c0bd30a573133a0ac485ac5b16d69"
    sha256 cellar: :any_skip_relocation, ventura:        "543824dc3140af8eccc7bea50100a009088cd3f0dac7d9f075ed7a5dd7e8dc3d"
    sha256 cellar: :any_skip_relocation, monterey:       "473c4f0c0f81a93ebee02d8d3257c9a7f644f4b73ed56fce88c2d10c7a2f29c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e01beae492ed31c2340baabf81d196f8d8217b4d9afcd48cc30fa8d519783c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d13f73000477872c1f702a27bfdfbf5b34d029432e2d2caeac9ce9fe6136def"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
