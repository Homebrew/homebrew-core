class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.29.5.tar.gz"
  sha256 "25862b23ff95f27ea0387ecc7835a51981d1038663e9bbb943d3582092f9e6d4"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4946c132902db6dd703a4d7ad880201d3ff10bbf7e2804e54146843533e262e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47ca02bd172dd455fca40da2331bdfcb59825c82d60c8be99845a0fe84548619"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbc7bc3ef1223454e8f429f240d69ad459255876b65cc5a62fb679e26d702a59"
    sha256 cellar: :any_skip_relocation, ventura:        "d126a870c505cd8fc625055d974493d0648b271b691c273bedfbbc85bbc9bc8b"
    sha256 cellar: :any_skip_relocation, monterey:       "900e3f01e5bf1109c08827c795080487717c075692731388040b6a7c59548282"
    sha256 cellar: :any_skip_relocation, big_sur:        "723f3eabc3d011bde2f1d79225d3aa6f9ce24aff871422a2498a715cccd87c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "031f1698fbe958290431bd79820f5fee6accb55b03b88d93106c6e598a3135e3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
