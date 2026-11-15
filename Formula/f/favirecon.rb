class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://edoardottt.com/"
  url "https://github.com/edoardottt/favirecon/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3cc64b241fc357cda44ea11ffbe036fbf7160049d0011c45a9963746e6e27bfb"
  license "MIT"
  head "https://github.com/edoardottt/favirecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a7d964296facadee66d77981d61d08016323fcbbd99b7eef7df8677c0b66ff83"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d9e6bd5dd74046d6224310df7849af0ea20e56ebbcb3d1eddb3d1f6d0240cfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56fd1bc13371aa525d2544287d70b7d1287bb4de9abe35e5d8e505082a695a05"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04549a65cf2918e31464d907dde355c2e17881cf2437ca14fdc06b6939adf5d4"
    sha256 cellar: :any,                 x86_64_linux:      "2e303a7873868856e1c6126187fc6531562e98d9c80cf85d9290d23cff07bcc4"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/favirecon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/favirecon --help")

    output = shell_output("#{bin}/favirecon -u https://www.github.com -verbose 2>&1")
    assert_match "Checking favicon for https://www.github.com/favicon.ico", output
  end
end
