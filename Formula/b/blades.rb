class Blades < Formula
  desc "Blazing fast dead simple static site generator"
  homepage "https://getblades.org/"
  url "https://github.com/grego/blades/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "e9ee64ead54e1942397ea5d6fcfd6ba928a888c1f4c127b11dec9fbadd283cc2"
  license "GPL-3.0-or-later"
  head "https://github.com/grego/blades.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9838e2378bc3bd9300c4fffe261590150be386b6e411fd071d56a47df01c959d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58917242c123198bee44ebf0b9d57f92ce86ea9879db7a3beb744d4a21ea38cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65e48a93926a6c28a4f056a17f433ce32afcb1bc937459ca671f629294f44400"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25a4ef2be400ac8c799eb18c9b531a4d30137f8e1d7dca05d4734ebe5bbfd213"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b686021040a3c826a056cb55757f18ac678889ead9cd11cc6220315da4fa8f73"
    sha256 cellar: :any_skip_relocation, sonoma:         "00bfa4fa8544dcdd87e5ce9bd953d369395e1bc8fd655a42c08b57628ffa5a4a"
    sha256 cellar: :any_skip_relocation, ventura:        "27bb16f34cfd0e165212d4e85c91f6b3f4548adfd8a6e67bde4643ff2889bd52"
    sha256 cellar: :any_skip_relocation, monterey:       "ca4e983b24c5375b4b8bf65bcbd828a04035c1a54ac1dd69d5304ca243d0e6f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6c2064c05c14d57321c87cf96fc764a0b5374d2459c2e0964a675a8a58ffacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c1bacb2b79fc1edf95554aafc1523ae05962bb68c651207bfeb3d8964afef62"
  end

  depends_on "rust" => :build
  uses_from_macos "expect" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    script = (testpath/"script.exp")
    script.write <<~EOS
      #!/usr/bin/expect -f
      set timeout 2
      spawn #{bin}/blades init

      expect -exact "Name:"
      send -- "brew\r"

      expect -exact "Author:"
      send -- "test\r"

      expect eof
    EOS

    system "expect", "-f", "script.exp"
    assert_predicate testpath/"content", :exist?
    assert_match "title = \"brew\"", (testpath/"Blades.toml").read

    assert_match "blades #{version}", shell_output("#{bin}/blades --version")
  end
end
