class Has < Formula
  desc "Checks presence of various command-line tools and their versions on the path"
  homepage "https://github.com/kdabir/has"
  url "https://github.com/kdabir/has/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d45be15f234556cdbaffa46edae417b214858a4bd427a44a2a94aaa893da7d99"
  license "MIT"
  head "https://github.com/kdabir/has.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e9e38ec67613f798b702a0d489566adf51ca3f2e7486b0f6960ce0b5fa7f44f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e9e38ec67613f798b702a0d489566adf51ca3f2e7486b0f6960ce0b5fa7f44f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e9e38ec67613f798b702a0d489566adf51ca3f2e7486b0f6960ce0b5fa7f44f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e9e38ec67613f798b702a0d489566adf51ca3f2e7486b0f6960ce0b5fa7f44f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e9e38ec67613f798b702a0d489566adf51ca3f2e7486b0f6960ce0b5fa7f44f"
    sha256 cellar: :any_skip_relocation, ventura:        "7e9e38ec67613f798b702a0d489566adf51ca3f2e7486b0f6960ce0b5fa7f44f"
    sha256 cellar: :any_skip_relocation, monterey:       "7e9e38ec67613f798b702a0d489566adf51ca3f2e7486b0f6960ce0b5fa7f44f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e9e38ec67613f798b702a0d489566adf51ca3f2e7486b0f6960ce0b5fa7f44f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1502866b1f3102cf0f8b94e0905dc649250ab1d6e5d1ac0154171a9d60a78a8c"
  end

  def install
    bin.install "has"
  end

  test do
    assert_match "git", shell_output("#{bin}/has git")
    assert_match version.to_s, shell_output("#{bin}/has --version")
  end
end
