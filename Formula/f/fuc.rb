class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/1.1.7.tar.gz"
  sha256 "7f61937d5dfce776ef7dcb86a8a97f6db5701a7a522474b99ce2ae36ad9d6248"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a1bf597bf73b9eebda1fa62c511d7a7f5e741668e12206b7f0a6e3c4f85441a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d208c38a9c944959542022cbf5eb696d530a9f8ddbf13deccbf6781d1c738e0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7aec474f8932674db9ca03323d91eb62971bf375fb773e6ce293e6a90a3f6bd1"
    sha256 cellar: :any_skip_relocation, ventura:        "253c490247c923680c4553c34f6f1c7e4e2130b261a74ae7c4a3e693dc093dda"
    sha256 cellar: :any_skip_relocation, monterey:       "efa27fd30f8fe40b177244142a7a89d7e3b2f54b3b5da98c5bad326f374c3e35"
    sha256 cellar: :any_skip_relocation, big_sur:        "97d6f4eef2d2985f2459cbf88273c8f613030a1677818de5df4aff49a6b53ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e83fd2c1e4ee43743bc3119c8e5e5ca513aa73e792b6bd43c3d8c945d91eba0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cpz")
    system "cargo", "install", *std_cargo_args(path: "rmz")
  end

  test do
    system bin/"cpz", test_fixtures("test.png"), testpath/"test.png"
    system bin/"rmz", testpath/"test.png"

    assert_match "cpz #{version}", shell_output("#{bin}/cpz --version")
    assert_match "rmz #{version}", shell_output("#{bin}/rmz --version")
  end
end
