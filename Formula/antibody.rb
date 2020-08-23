class Antibody < Formula
  desc "The fastest shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v6.1.0.tar.gz"
  sha256 "b2cf67af801ebf10c0d52b1767cbdb5e3ab5a1713e6c3d28616a109e1d7906a7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "34220ece903751e682659e9f76f069ec28cd6369373d0391d4298805a6f64a3b" => :catalina
    sha256 "3044c7a8f003006ef6f0b05ba590c4b41f578e377c02e5e9cb36ff7e18bad269" => :mojave
    sha256 "a0fc8f0db6b35280d073f046d83d00142e0104d5e7857ff04acdbcbe25eeeb40" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"antibody"
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
