class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.1.tar.gz"
  sha256 "9522d3df25cb24488e13a12a2d0ec1849c2f8c1b73d58fd07dd357d01ba6ee94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2fa597a3769988ab6a79b4fcd9b48c31c4bec93545415d08bb453a8eff981b6f"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d53d24d102c398bc0fc5b226d9c8284d84482bbe8ef6963a7a112832b1013db"
    sha256 cellar: :any_skip_relocation, catalina:      "f4f07cafd63a7ca49b9a19124b4da8ed882306b0654452dbf1f427a8264ff136"
    sha256 cellar: :any_skip_relocation, mojave:        "a527e0a1ba3c50214fd09a0de4eaa09290620ab6f3d460ed4b35a2840f572404"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
