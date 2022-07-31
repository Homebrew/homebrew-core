class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/v1.5.0.tar.gz"
  sha256 "07e18ce606feb8c86a1f79f7f5dd724079ac27196faa61a2cefa5b599bbb5bb1"
  license "MIT"
  head "https://github.com/aptly-dev/aptly.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfed7144faee9ecf6c6f1d17c62f8f421655d32f19375a76847f54a8c8eadbcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e87f870317644e20437b88d8c41c2af49a6f8094b5a8a791a22a21d1110aeb1"
    sha256 cellar: :any_skip_relocation, monterey:       "a22d51e4d224df6aee376957eccc2794c8c958f00c984777e48f28419a6b78bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9215c97346fa95bfc6766a3c9f1e52d93db83d6a621676abe4f64c7796a894b1"
    sha256 cellar: :any_skip_relocation, catalina:       "2a9bbbfb27151d55e385a5731bf6a166f31d647238d3aa6c28ee5783874e4c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16e4a617927df43a88a0eeb394433f1d72776e3e24fa08e126c86050707d7878"
  end

  depends_on "go" => :build

  def install
    system "go", "generate" if build.head?
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    bash_completion.install "completion.d/aptly"
    zsh_completion.install "completion.d/_aptly"

    man1.install "man/aptly.1"
  end

  test do
    assert_match "aptly version:", shell_output("#{bin}/aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
