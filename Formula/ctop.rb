class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop.git",
      tag:      "v0.7.7",
      revision: "11a1cb10f416b4ca5e36c22c1acc2d11dbb24fb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cacf1e287ff25e701de9c1472d462377e8bf90cc5733defe595b5c0f5848ab64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec4b96f4c4eddacb20dbb142c430ed9b8ba975519e7b383eb0613bf7f62092a0"
    sha256 cellar: :any_skip_relocation, monterey:       "523a700771377a75e6da967df31d5f878d9a8ab52ab4412e10aa294ac183074f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dc1e0a2f6cb7fe27e7657e3bb0ba2825e8f730f4a1da6e98273f9f88aff0b2b"
    sha256 cellar: :any_skip_relocation, catalina:       "0a358054ae920a6c520fbee9fc3d3d18b5a78d12aa77918240ead37aa56fae1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30607fe87d023df1ab88efe82c18af28e5276cfb8281de6b51bdedea41b5179e"
  end

  # Bump to 1.18 on the next release (0.7.7 or later).
  depends_on "go@1.17" => :build

  def install
    system "make", "build"
    bin.install "ctop"
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
