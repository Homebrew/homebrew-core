class Clac < Formula
  desc "Command-line, stack-based calculator with postfix notation"
  homepage "https://github.com/soveran/clac"
  url "https://github.com/soveran/clac/archive/refs/tags/0.3.5.tar.gz"
  sha256 "ae0a989ba3efc5dbe8480aed5fe39e79e274ea51271bfa7a0193d73cca0b9711"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce7b9be1e3f562a2f9be027bc7d521ab4495d6e7a27b6b2b3883b855aae67c29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b83f24a4d7ed1ac56bee1eb3088bd43b5fa6e3b03653e34097efeca25371aed2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "876e4eb45a9824c10b879c0f78480aa8ea9cb16c8bf920ecbf5efc7ccb124dc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "06eab05243dc3fe10dda4e1e04a419ef568ebe1c7275381d646da1dfb455f99a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32529a83e8e0dad368f129c2509d0a6d67538455934d2b48d49c715ebe69e18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7938397708c73afe67e251fc647f7dbec82854b1b5590acdf87fe09a8d696fbf"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "7", shell_output("#{bin}/clac '3 4 +'").strip
  end
end
