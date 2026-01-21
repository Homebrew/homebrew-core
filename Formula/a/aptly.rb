class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "cadfabda2a59f397adfe6f9ce3c9ddc6fe4c6052f0e03a300ba1f22d7cf0e09a"
  license "MIT"
  head "https://github.com/aptly-dev/aptly.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba67fa93b8c34004f46f52be6bb9db588833f14e195c7225184a6a8bc3ad14e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eed18d1e90c95d9f9d27c1bb4071b5918df5102d674ed4377f5ed48bb19963c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eed18d1e90c95d9f9d27c1bb4071b5918df5102d674ed4377f5ed48bb19963c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5eed18d1e90c95d9f9d27c1bb4071b5918df5102d674ed4377f5ed48bb19963c"
    sha256 cellar: :any_skip_relocation, sonoma:        "13d85438f90917d1e5e0ec47d983373305e5cdf6880c8eca78d95dff2c6c6e29"
    sha256 cellar: :any_skip_relocation, ventura:       "13d85438f90917d1e5e0ec47d983373305e5cdf6880c8eca78d95dff2c6c6e29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "816f00ebfe70c1dfeba581f6b8b3e046b727b7cd1c0aa49e2213814e4b22d505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff56ef982a5265758be69344b4d222bebb20bc969382bffc6110604a627e3f2d"
  end

  depends_on "go" => :build

  def install
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    bash_completion.install "completion.d/aptly"
    zsh_completion.install "completion.d/_aptly"

    man1.install "man/aptly.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aptly version")

    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
