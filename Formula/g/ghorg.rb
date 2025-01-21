class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "04ea9d2137e5a2cbde46b7ce6519e46cce182436b0d91d45b813411407ac2991"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55ec6c7e3d35a14c51438eff5bf7813f1fb2420de4ac58c58d32eddac1c9ca1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55ec6c7e3d35a14c51438eff5bf7813f1fb2420de4ac58c58d32eddac1c9ca1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55ec6c7e3d35a14c51438eff5bf7813f1fb2420de4ac58c58d32eddac1c9ca1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba87250009192327b3a1cf3a40567878cebb283bdeaa528616a116462a380e0d"
    sha256 cellar: :any_skip_relocation, ventura:       "ba87250009192327b3a1cf3a40567878cebb283bdeaa528616a116462a380e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d74f1ff3648ff86014b46762f3e70319806b39b027189712a3fd2ed7c18a5e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
