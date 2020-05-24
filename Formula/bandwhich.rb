class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.15.0.tar.gz"
  sha256 "c4922734bbb3ec17c8a0c9fbff4096ee3e28b4efa7dbca9abbd92e0ad6ff3483"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb963089848f4c9bb994c8cf3e1842b3ba6d70a2320b0f2a58e537c6ba857a69" => :catalina
    sha256 "2a2364b3fecd65bbd92151c5ac165cdfb79ad0568fe13545a7691332e509d2f8" => :mojave
    sha256 "530155a24c7c701fd12455a53d2d4a5af7022ad054c3c27a22d82a50524e5d1e" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
