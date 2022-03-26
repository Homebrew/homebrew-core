class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.31.0.tar.gz"
  sha256 "f82694202f584d281a166bd5b7e877565f96a94807af96325c8f43643d76cb44"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a2bf97696f0e57e713db8f39dcff719fa17e0512b6ad14a7657a1c946943a85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41d4f105cdef28417dae6c248a5819709967897071c34ed63fa5432644d944f2"
    sha256 cellar: :any_skip_relocation, monterey:       "761499a99dc029d5cafe075105827c4897d5e45dd53cfa7bf86ea51fc4f1afaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "73fc3e19b391c97806c44d2f2b38b5ddc28742d656ab6ca013371acc6cabd5bc"
    sha256 cellar: :any_skip_relocation, catalina:       "77c87b8f6ee51b65514b5688babcd83117b75feb2b40b0489bd0649cdeb3f3cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b18ff46bf3e0b18eace8b2a0754829555a991d58d6fe3f76681a8a057c48a04c"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
