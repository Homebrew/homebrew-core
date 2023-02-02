class Nomino < Formula
  desc "Batch rename utility for developers"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/refs/tags/1.3.1.tar.gz"
  sha256 "45e8ed1e3131d4e0bacad2e1f2b4c2780b6db5a2ffaa4b8635cb2aee80bc2920"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "nomino-(2020)-S5.E1.1080p.mkv"
    (testpath/"nomino-(2020)-S5.E2.1080p.mkv").write "brewtest"
    system bin/"nomino", "-ep", ".*-S(\\d+).E(\\d+).*", "S{:2}E{:2}"
    assert_predicate testpath/"S05E01.mkv", :exist?
    assert_equal "brewtest", (testpath/"S05E02.mkv").read

    assert_equal "nomino #{version}", shell_output("#{bin}/nomino --version").strip
  end
end
