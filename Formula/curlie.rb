class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://curlie.io"
  url "https://github.com/rs/curlie/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "95b7061861aa8d608f9df0d63a11206f8cd532295ca13dd39ed37e0136bdcc5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98627f52c4737c631f5e7f90b3f036bdbe9f9e1c11932ee451794eb7add782c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98627f52c4737c631f5e7f90b3f036bdbe9f9e1c11932ee451794eb7add782c5"
    sha256 cellar: :any_skip_relocation, monterey:       "bb9cbbb7ca13f987707332837474404f606c499d9f411db18d88e5d86d995cb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb9cbbb7ca13f987707332837474404f606c499d9f411db18d88e5d86d995cb6"
    sha256 cellar: :any_skip_relocation, catalina:       "bb9cbbb7ca13f987707332837474404f606c499d9f411db18d88e5d86d995cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a851ca189f46f1d4b7a76c29cb6f0d36c37f6a73f0800e944a0bda4632fe3ff"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  uses_from_macos "curl"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "httpbin.org",
      shell_output("#{bin}/curlie -X GET httpbin.org/headers 2>&1")
  end
end
