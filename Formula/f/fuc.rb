class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/3.2.0.tar.gz"
  sha256 "2f9f3572e7a956015593ec7e5f8225f704601404bac7d1e471e1d67632cbf074"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "233689ca282c04d10b6110abb317240f458dfb7d52f55a3e479fefc7a950505e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec876dd9f75bd22e4195cf5a7814103c272217d1ce75ae567728bcbf6fda4bbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5954bb9c04258d9115a63d1be7a7924428aec2f5177ce1219080b216599cdf80"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd510b9bf56bb0553a5295dc4966dcaf43dd0397d610b4195179052544aa513b"
    sha256 cellar: :any,                 arm64_linux:   "78270c2365ffb15103240718c3ce4e36bb80c464f898d8e479668f98ef45f892"
    sha256 cellar: :any,                 x86_64_linux:  "40ac06437dcda2e1b1ce57ad2ec77373435cefb895f013874254c8993a7e4919"
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
