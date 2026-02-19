class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://rs.github.io/curlie/"
  url "https://github.com/rs/curlie/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "846ca3c5f2cca60c15eaef24949cf49607f09bdd68cbe9d81a2a026e434fa715"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e6a403c17aeeb561d9109f7219acbfb130d19516330eb7c91981d2cd8f5aa4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63443e27253ec013a3bb25c18a4c1f0da439ce63cf484e5dd18fdc5e56be082f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63443e27253ec013a3bb25c18a4c1f0da439ce63cf484e5dd18fdc5e56be082f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63443e27253ec013a3bb25c18a4c1f0da439ce63cf484e5dd18fdc5e56be082f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0989be89b84c97a2e8b9e1efcf124844728919f3ff7b9aab9bb3d832f042358e"
    sha256 cellar: :any_skip_relocation, ventura:       "0989be89b84c97a2e8b9e1efcf124844728919f3ff7b9aab9bb3d832f042358e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9cbe19380adf9f5226a886617ebaddb6fda4fb1fb1a130851a128f88f46011b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8923e92fa583529ba8dcbdea7eacda66601bece881eeb33217787198a3434dad"
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
