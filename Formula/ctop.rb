class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop.git",
    tag:      "v0.7.3",
    revision: "4741b276e4bbaa41a67d62443239d50b5a936623"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d91134c9c0f82fa52d66316b3ce2508e6c53878e2bfcbb937a62f33bc0267d0c" => :catalina
    sha256 "c70a8b08c6acf81b7c1b8a3183da8d02218be1ab966f5357c1ed537f4830b258" => :mojave
    sha256 "fe7d332a2e1068be73ef3ef524745ddf444b77bcc0f67b8368e4fc78f3abb69e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ctop"
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
