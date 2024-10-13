class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/35.0.0.tar.gz"
  sha256 "5ab642bb91ad9c1948de1add2d62acec22d82398e420957c191c1549999eb351"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0b71d8d70e749ebe94c56fcb8e1fd7b6f1011089efa35047b55e555f5a6f7406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ac980c80f98aa4a5ea9bd21d1a17b0080ada804f9e189d0dd91810f4f829048"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ac980c80f98aa4a5ea9bd21d1a17b0080ada804f9e189d0dd91810f4f829048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ac980c80f98aa4a5ea9bd21d1a17b0080ada804f9e189d0dd91810f4f829048"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b04e666a49281880912c45d2867df85f1bc699e0472161f83f017a2e5e8472c"
    sha256 cellar: :any_skip_relocation, ventura:        "4b04e666a49281880912c45d2867df85f1bc699e0472161f83f017a2e5e8472c"
    sha256 cellar: :any_skip_relocation, monterey:       "4b04e666a49281880912c45d2867df85f1bc699e0472161f83f017a2e5e8472c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70b778921a29c92bb09b7f9e6a889100b90173b49c66c674beec0974fe8d30be"
  end

  depends_on "go" => :build
  depends_on "node"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end
