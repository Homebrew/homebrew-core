class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.32.tar.gz"
  sha256 "e0a6abbd168c51d45101d511faa1989c0cf4c994f94a4f55c556b3b9c9c70cd1"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e24b69e3457421be7cf67124ae2b97ae359522f0072785cae8afc6f58a0fd7ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b84bb900fabad6f5f70b4de3a07a1ab4bbf7618af7d45e27d44584d9310a47ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5acba91a1ca9cf9445405dd7ab78e6db8a0ff12a46823c60588103d68bd42e92"
    sha256 cellar: :any_skip_relocation, sonoma:        "082c03510a49ef601e57689f5cdd498ba5eb75684a71f972f64d376ae1b5db4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5cfe3f33b59d959f71a9d0cedb13a21c0ed6821dae325164296421790572fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40877ba3f8b8d74786c66c335d99c728be7d03d9cf1856730aefdf434fd8de90"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
