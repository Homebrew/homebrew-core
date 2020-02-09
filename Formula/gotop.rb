class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/cjbassi/gotop"
  url "https://github.com/cjbassi/gotop/archive/3.0.0.tar.gz"
  sha256 "d5147080bb6057f0bf0900b38438e89aa066959c845bdd4c84a9c9fe478b176f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e92acc3b1327317f9a5a6a09fe841d4cdf116ebeb3b225fa73d28b10a21d0170" => :catalina
    sha256 "fbf79c06ef6ef84bd3f3f28fba3e49308e295f816facd0f6b7f696d6789e69a9" => :mojave
    sha256 "58606da95a9fc75bfca7646e32e1f14e90fca4600b2bffddf5a7c14fbe3f3268" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags", "-s -w", "-trimpath", "-o", bin/name
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/gotop --version").chomp
  end
end
