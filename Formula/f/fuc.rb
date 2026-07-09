class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/3.1.7.tar.gz"
  sha256 "e3dda4699ff12a08336e93120c55c172b296f6be64de202350eb5b3217078c10"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fef8533f3e0cd66482116904805c0b9e8dd9f636d01d7fb96a4a3f0e4eb90606"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5460750b8d7686aa16852ccb0ced8a02c92a3ba537c036fddd2fff253a26fd81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cc4db0a9268a20a1b43b32fea5a78054ce305fae3c09aa81f7a97f36f52b898"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd0df5e3214c5e1f87b7045a9a5abdd2422ba82b6ffdcf95839b537f1f58fc37"
    sha256 cellar: :any,                 arm64_linux:   "76376d1e8319344dea83209c31ca70e24c9d4ce69bc74f66db74d8e892061a19"
    sha256 cellar: :any,                 x86_64_linux:  "6b517fe89ff62086eb68d825989d1d6431a44b6d741f016d51f94c0284c7fd40"
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
