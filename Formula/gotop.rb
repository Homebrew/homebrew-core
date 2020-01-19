class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/cjbassi/gotop"
  url "https://github.com/cjbassi/gotop/archive/3.0.0.tar.gz"
  sha256 "d5147080bb6057f0bf0900b38438e89aa066959c845bdd4c84a9c9fe478b176f"

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags", "-s -w", "-trimpath", "-o", bin/name
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/gotop --version").chomp
  end
end
