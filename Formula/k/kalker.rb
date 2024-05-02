class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "4f34d34e922308e586fd9f7077e1cba126f3e75d269f4859d0472bb565ce1d4d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7e8a9929f77a7fd009e0290793fe22518d945ef362cf980876ce62cc48f25b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00c3b095d17680177a8aa6de792b5086f6eeb11291543b5fb57bca8cfa31562f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69fdaed91c5a9ce2cecb38ad7873ca317617ae727bcad99f34b705344263fa5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c68b74e2490526623a47f2f4195c1824f1eda787fccb20da9a8a34d49bb918f"
    sha256 cellar: :any_skip_relocation, ventura:        "b0a2540f5dda3f93061e7432fd9180b03c76bbe9c08f267241099a11e8bcb0c2"
    sha256 cellar: :any_skip_relocation, monterey:       "185cf3399accd7bf448e22b20360aaceccf9e94c4d57b86c3577bf0f8b574e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed47375080db64cb26b84b1733f093216e808f4b87d55bcfdf5218104adb084"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(n=1, 3, 2n+1)'").chomp, "= 15"
    assert_match version.to_s, shell_output("#{bin}/kalker -h")
  end
end
