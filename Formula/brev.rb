class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.190.tar.gz"
  sha256 "4c5fb4d265e98b8dc87665843110434baef4d6ad0601e19e3764b065f01d5423"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ddc4782b1f7c73647dc5d8afac6162c52bbbbd79e2d1c1261b649fe87b7f125"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aa043afc1c7df0ea21a7f750c8111c18f2b10b8a7552ffc9665315048cc8714"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "821e7734f569fc14afca8525646f98cb6254186d10fac7cab7a136e372b0fa72"
    sha256 cellar: :any_skip_relocation, ventura:        "8724820d2c408e1564d889935f72c4762e03de9e3fa7cde10f0a5f86686adc35"
    sha256 cellar: :any_skip_relocation, monterey:       "de6708f05ee8ff0168044ad4f4d886cee5e40da0b0c616fdf9416fd863118e20"
    sha256 cellar: :any_skip_relocation, big_sur:        "27d1d30fd693bca47d63cac35aafe3c3b4eb5d008669ee1322deb2e658200188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73ecf66d5f7243d7554854709ddaa25ee06902995c44d8e17d67eccc3b05e829"
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
