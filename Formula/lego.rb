class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    :tag      => "v3.2.0",
    :revision => "11ee928ace97cc5f274df13da015f5f84ae3756d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "faadf684bc039a30f718190565dbfd7f0c353a754cb0f5116e6c4bdf77286424" => :catalina
    sha256 "fea578fafd709af5e6fcc291f489b5eef32908d1386f22b0041b632bd939544f" => :mojave
    sha256 "4da303e650d6d047be85d3afe4f9a06c6ddf59be9ea47ef404761e93133d2c93" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath",
        "-o", bin/"lego", "cmd/lego/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
