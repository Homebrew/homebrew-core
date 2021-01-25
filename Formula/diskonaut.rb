class Diskonaut < Formula
  desc "Terminal visual disk space navigator"
  homepage "https://github.com/imsnif/diskonaut"
  url "https://github.com/imsnif/diskonaut/archive/0.11.0.tar.gz"
  sha256 "355367dbc6119743d88bfffaa57ad4f308596165a57acc2694da1277c3025928"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7cf4cb3d65059185ab893d3f76d09adf0bab139f0410e2d072f0a3b9811c167" => :big_sur
    sha256 "6d4fc3eb1244ec14a1719e29e97a5a884a6a48c5918ed0df626db002312be23a" => :arm64_big_sur
    sha256 "8386cdc8f2798b2d7dfe52982433a62d9a05ce04fc64e13c909324b9c1b623c7" => :catalina
    sha256 "75b42c75f32c0a70a681345ad60ed93f9ad4c54751a949c4efc15d859f60c6d1" => :mojave
    sha256 "f1d1c2cf37df515ef13ddf5cfd6cc96c73a734911d682f24d1b45f60af93b20a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "ls | #{bin}/diskonaut", 2
    assert_match "Error: IO-error occurred", output

    assert_match "diskonaut #{version}", shell_output("#{bin}/diskonaut --version")
  end
end
