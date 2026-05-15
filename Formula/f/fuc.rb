class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/3.1.1.tar.gz"
  sha256 "a26265c85d1f13fec555606a8aaa5b978d84e637de2b3cf321dd85c843339f93"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eb97d285b25f3b351a962c0337c2c8d4068623a6fded827eb1a6881823bb859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "922d25d5722345f87db9538f0ac9f874f0c1704d9e3a5c76616542b39946f31a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9c8e9a362bd9d9e75260e34a7dab484e6e5952837297561913e23f154adef36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "611ecc7ae60430242540d1c9914a396e6ee3d0d332a120b13467e3cc4d8ce0c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "12eea25b2e7186591f94a4562d18de6d841bb3ae46f89a90b28d78532a762edd"
    sha256 cellar: :any_skip_relocation, ventura:       "7721f0285f24ef46a14c0bec6e7572e949db387caecd6a9d0612b3f42b0bbade"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c03bbd8be10360367f47b2297d333c0f1bbc2f1fd9f1f993d0af6d76523ebfdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a0972d6b58867a0183cd447faacc117e7900f168f8150e7a10b73dadf8520e7"
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
