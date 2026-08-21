class Hellwal < Formula
  desc "Fast, extensible color palette generator"
  homepage "https://github.com/danihek/hellwal"
  url "https://github.com/danihek/hellwal/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "78cea94425b35a4dc377e498921ddb2927b093ed6b825606554f25b98699310c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfc5e8ad72740938b145df1f38466551c055a2fbf5119859a7cd35423a68d54c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96f793601bdf6475d4d23ceb1f187acd6e8d6847975c4910ba887044cc655e31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87cd5c204b43091bc96917c0b6511517eb93b89b2f5d8c85ed7a61203bb4425f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82a9c9ffbfd161281dcf0171794cb523396ba53f3489ef5f2ce64d21fe87b964"
    sha256 cellar: :any_skip_relocation, sonoma:        "30c0b0f64a0de8093a854c19a8f18ac5dbc3113f49182b874d18bfd663948b54"
    sha256 cellar: :any_skip_relocation, ventura:       "d753966a3b24aedb2b838060414951b9f05310c6cf10ab7dea0d0f40f5ef058c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a2eba338afdcf106cb12a2a6a8213c53b8996309e1cae25364bc4e403f7b169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd4d1a76335f7fe6a12d94124cd2ec8f3a0d72eff2f3d5bdf0375894d79d715"
  end

  def install
    system "make", "install", "DESTDIR=#{bin}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hellwal --version")

    (testpath/"hw.theme").write "%% color0  = #282828 %%"
    output = shell_output("#{bin}/hellwal --skip-term-colors -j -t hw.theme 2>&1", 1)
    assert_match "Not enough colors were specified in color palette", output
  end
end
