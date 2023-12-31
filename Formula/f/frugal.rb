class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/refs/tags/v3.17.6.tar.gz"
  sha256 "b9cc9261f29f46fce7989bbe1795741ff8fd6fb240874114af759340c5ea1e46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef2fbfa5c41c03e0290e05f2d1ab2cd6eb97ce71e44b593fe1e0949aec980e46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef2fbfa5c41c03e0290e05f2d1ab2cd6eb97ce71e44b593fe1e0949aec980e46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef2fbfa5c41c03e0290e05f2d1ab2cd6eb97ce71e44b593fe1e0949aec980e46"
    sha256 cellar: :any_skip_relocation, sonoma:         "195a865aa3fc95f0cede636587b09e2a328376fa4aa0e4c3c6c75e165080d6fc"
    sha256 cellar: :any_skip_relocation, ventura:        "195a865aa3fc95f0cede636587b09e2a328376fa4aa0e4c3c6c75e165080d6fc"
    sha256 cellar: :any_skip_relocation, monterey:       "195a865aa3fc95f0cede636587b09e2a328376fa4aa0e4c3c6c75e165080d6fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e028756c542e375271b57089af5b3b22556d30f592ad3a5f029cbf0867089be6"
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
