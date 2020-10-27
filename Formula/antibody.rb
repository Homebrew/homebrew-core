class Antibody < Formula
  desc "Shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v6.1.1.tar.gz"
  sha256 "87bced5fba8cf5d587ea803d33dda72e8bcbd4e4c9991a9b40b2de4babbfc24f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "572351da6247daf6bf29afbdcc8ff10c4fe47e9e413c2ae0df0dd249e855599d" => :catalina
    sha256 "c33467a9d42a9c767bd2d3382937e9f1dcf9bce2cb45fe3de6adb736ae2d6e89" => :mojave
    sha256 "7af2bd8779f129597713ebd6155d493616f4ed4b2344cac9db84191b01f3110c" => :high_sierra
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
