class Licensor < Formula
  desc "Write licenses to stdout"
  homepage "https://github.com/raftario/licensor"
  url "https://github.com/raftario/licensor/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "d061ce9fd26d58b0c6ababa7acdaf35222a4407f0b5ea9c4b78f6835527611fd"
  license "MIT"
  head "https://github.com/raftario/licensor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ced2f38da0f60e150836a6e9b5a8d4552f74779ef3059c708c1a325c6e8b7a00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b107c7fdf50267fca917c134940c0147cd4604ecb0ad1c2df0c2deeddc62b542"
    sha256 cellar: :any_skip_relocation, monterey:       "8444527ca924949045edce53ff444f25b96823ab8d99835d4e60cc9264576379"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fe890312aaebe71da671a94c192c952fb46b1afc0f8f7b9f7a6933a25c8be7a"
    sha256 cellar: :any_skip_relocation, catalina:       "16315e2c93f90aadf94c47fa73066f5d2f89c7d9d5923700a32d08a806f95284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6dab62bd32bce3a4958d79111b496f9f21fbf7a94fa9a791fd21fc442175395"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/licensor --version")

    assert_match "MIT License", shell_output("#{bin}/licensor MIT")
    assert_match "Bobby Tables", shell_output("#{bin}/licensor MIT 'Bobby Tables'")
  end
end
