class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.8.tar.gz"
  sha256 "ca1bcf131b12a8eae69c091a6582a3f880c93fb9966e2bd7b52e537385982349"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "712ca37ce2aa54aa8273596c2e7eeaf9ac40de760060a417d4d14738daff82bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e5e71e4567cc67d59cd33c009cee51a2372cb1973e004ff7313031318ae657f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "199c81a92c50a67890377b31eb295fe4d0af91e716449ef2780d6670a630cf18"
    sha256 cellar: :any_skip_relocation, monterey:       "6f2ecbe7b38b68a257a263d530cf776cd2882ae965e3f6dd8598fe1bf1436569"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fbc340b5579deb50e1d1ec3bdb6f7055e4c3d4047a0aa92c2a02816881ccd1f"
    sha256 cellar: :any_skip_relocation, catalina:       "e0679d007890aaf173281bfc8007e9ad46d4cd6503b2fba97b8dab7e81034ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c66afec0e1e77ab952e8b6a6983e05e6058e77be72cb42969da5d279a8bf8763"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
