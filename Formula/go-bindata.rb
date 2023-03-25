class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v4.0.2.tar.gz"
  sha256 "ac343c4b316b234b8ea354d86eb3c7ded2da4fe8f40d45f60391d289c66cd950"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6570db41342e68d30388d4850526b3e5e78c67ca85b9b4e23304bdc474eecbab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6570db41342e68d30388d4850526b3e5e78c67ca85b9b4e23304bdc474eecbab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6570db41342e68d30388d4850526b3e5e78c67ca85b9b4e23304bdc474eecbab"
    sha256 cellar: :any_skip_relocation, ventura:        "b086457f57ebb4fb15434d13ceed667719983fa6cd1be7f07c15b59b12a9449e"
    sha256 cellar: :any_skip_relocation, monterey:       "b086457f57ebb4fb15434d13ceed667719983fa6cd1be7f07c15b59b12a9449e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b086457f57ebb4fb15434d13ceed667719983fa6cd1be7f07c15b59b12a9449e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f1291b2bbf58d7d0e7977d9ba8b7f50f85e8f43e3d7046a8c737061b73a1ca6"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./go-bindata"
  end

  test do
    (testpath/"data").write "hello world"
    system bin/"go-bindata", "-o", "data.go", "data"
    assert_predicate testpath/"data.go", :exist?
    assert_match '\xff\xff\x85\x11\x4a', (testpath/"data.go").read
  end
end
