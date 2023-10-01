class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/30.1.1.tar.gz"
  sha256 "650f8e1079256b8c97d57eb7963c81763ab63096edbf10bb145246e495f6cdc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "376986ca283f4a51763a4529c164ec37a46a40ef8ad33f2e4dfef25d96837183"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "376986ca283f4a51763a4529c164ec37a46a40ef8ad33f2e4dfef25d96837183"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "376986ca283f4a51763a4529c164ec37a46a40ef8ad33f2e4dfef25d96837183"
    sha256 cellar: :any_skip_relocation, sonoma:         "81b78b6d385bf2b2a30d8a3220b95d8c238e5cb1cfd0519a0d4a32f70c7f0da3"
    sha256 cellar: :any_skip_relocation, ventura:        "81b78b6d385bf2b2a30d8a3220b95d8c238e5cb1cfd0519a0d4a32f70c7f0da3"
    sha256 cellar: :any_skip_relocation, monterey:       "81b78b6d385bf2b2a30d8a3220b95d8c238e5cb1cfd0519a0d4a32f70c7f0da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dcc7e7ccd90b604a7e36911d6418cf080124b24e51c0fb12f5ed7a6ea905ed0"
  end

  depends_on "go" => :build
  depends_on "node"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", 42).strip
  end
end
