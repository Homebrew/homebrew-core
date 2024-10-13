class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.37.tar.gz"
  sha256 "d78a4d216d883872a1e496d68a8e3dfe8044313d3104f1bcc4699355a7d3b977"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de887938c6b072eebed5c1f86ce23e7aadf79d0ebeb75981cbc832457f27d11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b37ecc15eba89911b76258e5273f86909d68617403683eaf560b7a07bb33a352"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1497a2fe5510a23b872281185f95f3bf77c9f1fd1b59768617503dee8acf3f47"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4ace8ada5ba925edbb4c772af9908b1b93d33b9dbbce9a9743753281f17716f"
    sha256 cellar: :any_skip_relocation, ventura:       "1c86e8bc23addac77206119d40112c37a83c91bdbb9da2b422abcbb47bda9260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2e3fc06bf634ac4d73afbf2c9651137b08b329069c627f67f4e0813ff498fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output(bin/"overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
