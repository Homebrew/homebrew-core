class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.25.tar.gz"
  sha256 "7e52acfa3625f1ad0564520faa79f339670731189a90cd259934034d740a7ff9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47a103504327a77979f1697a0df1d8fe08f91b613f05601c8aee486e66c8d3df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4099d025d6d66c860d6f3f41176976361ecab8fad42b290d83f07734137ef377"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9008697d21a397316fcbdd3dc46918903bd4ceeacca066b2629b1d292fe8d9aa"
    sha256 cellar: :any_skip_relocation, ventura:        "f2f37fe83e13663e2607160e2399e701d1e7c2734884b949fbf5061e5560e6b0"
    sha256 cellar: :any_skip_relocation, monterey:       "c4cbd5c30e101fd2f090ded1c41d1668341ccca3bffb01a65a78e52856226eb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a611ac0cb93d52c81104438a939527f01292aeec3ae710bde20dcd5559d514e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa1f79da3d67e841e864d33c954b655a7b134dfb5d2c74c32a0c2ec651183b21"
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
