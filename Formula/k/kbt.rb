class Kbt < Formula
  desc "Keyboard tester in terminal"
  homepage "https://github.com/bloznelis/kbt"
  url "https://github.com/bloznelis/kbt/archive/refs/tags/2.1.0.tar.gz"
  sha256 "8dd3b9c129b51e902f1b0aeb5a717c716d92f81ed76c2264a9131f8def428e93"
  license "MIT"
  head "https://github.com/bloznelis/kbt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba6a98a3b3b84992ec766d517d9d29e5ad5b01313389a126945418b9c7e01bec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0120aa35263ade59259cbd0160aede274aec0e9b596d1fa4d54af2456bb0a030"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bf5988a3d481965811ae1b35a2da6396e548b3691142a1285b73ec199aa74cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0b91f3101be3a1c6a433602c7f629091bf5a689ecd8ce18eef413baafc267c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac9a8d2c6fbb46d83056267b83050a1384b66ceb48d7cfd784e80215e84baabc"
    sha256 cellar: :any_skip_relocation, ventura:       "24a8ec918a6dfea51eb963c9538e7523476ba09680eee1252dc17fd37bad9f71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d293593b2dc1f1b6eb0b9121dd9b465b8ed9f662c5018abf830089c5a9ea2301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "811dc47da36e5d3914fc3c14fd0e2c4a3a797e1fadfc12191947c889d3fbd805"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # kbt is a TUI application
    assert_match version.to_s, shell_output("#{bin}/kbt --version")
  end
end
