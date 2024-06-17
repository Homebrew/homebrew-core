class Cariddi < Formula
  desc "Scan for endpoints, secrets, API keys, file extensions, tokens and more"
  homepage "https://github.com/edoardottt/cariddi"
  url "https://github.com/edoardottt/cariddi/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "422d5d764ff44c7226947aa82a1396e6298082db2582ba320d41043aa700dbb1"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/cariddi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6acb2ca7cc2008a0a64ca95092053bcf5d2e0eaedc2ea034ad2d49c0b29b0f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5c3c6141c6795e870a659106c8d5cc37d06298c67e24a418183632ea139a126"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a681726e2e275f0bb08ab03f7d028613cd7c9e81d158ea324245b572c59fc55"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a3cd85ccb2bb062eb6823d6a70b2b1c76af0c4aba1cf4ea6c3649b35ba4af8c"
    sha256 cellar: :any_skip_relocation, ventura:        "97c404221fadfacac29325d4da0b285ee894ec8c32e7acb2831a5bf5eb4dd7a7"
    sha256 cellar: :any_skip_relocation, monterey:       "e57ee9bd492ede18af385e17e7c81dfcc8fa1a3e1f255bb31c340cae3f6df6d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e88f16026746282e5f5b5b085187a97532c82eba50058b3adad31c4911e59578"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cariddi"
  end

  test do
    output = pipe_output("#{bin}/cariddi", "http://testphp.vulnweb.com")
    assert_match "http://testphp.vulnweb.com/login.php", output

    assert_match version.to_s, shell_output("#{bin}/cariddi -version 2>&1")
  end
end
