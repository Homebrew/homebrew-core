class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://curlie.io"
  url "https://github.com/rs/curlie/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "b2ced685c6d2cde951cbd894ecc16df2f987f9d680830bcf482a7dcd22165116"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "acbbd0d3410d0700c655c45233c9bf2d936f5e7ac6fe39cee18a2aba2ab118a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47bf51d69cfc8d16acc0e7a7754d67cff06e934f1df856c7c62d4cb117ce8d05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47bf51d69cfc8d16acc0e7a7754d67cff06e934f1df856c7c62d4cb117ce8d05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47bf51d69cfc8d16acc0e7a7754d67cff06e934f1df856c7c62d4cb117ce8d05"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4bf5ea0b7864ba51f58e6fe41fca0f8ea55a1455f55445129685135f849c1da"
    sha256 cellar: :any_skip_relocation, ventura:        "c4bf5ea0b7864ba51f58e6fe41fca0f8ea55a1455f55445129685135f849c1da"
    sha256 cellar: :any_skip_relocation, monterey:       "c4bf5ea0b7864ba51f58e6fe41fca0f8ea55a1455f55445129685135f849c1da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef8133ced104b6e62026f4c285e60870805c9c96b85ad2583d1af3e55c2695d8"
  end

  depends_on "go" => :build

  uses_from_macos "curl"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "httpbin.org",
      shell_output("#{bin}/curlie -X GET httpbin.org/headers 2>&1")
  end
end
