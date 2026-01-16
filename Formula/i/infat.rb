class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on macOS"
  homepage "https://github.com/philocalyst/infat"
  url "https://github.com/philocalyst/infat/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "116c0064ef15bccd358cc067ed52fefc745c6108854c6516d74c8c77a1ed437f"
  license "MIT"
  head "https://github.com/philocalyst/infat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1f2cb6fd37b0c763c9fc03395c13858dab043c4d40d2c22762878adfbc7ae02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43dd403f5cd8c8a778e1282825fc745fb616a34dc04362ce357b1d24e83e7a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5326c2d384749be109e9c5cf01b378fd0bf7f6eaee02d8751569249cba98b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9e02db5993f76fd6dd7355acba247259de511a6fc70d03cbafe29cde80fc16b"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on macos: :sonoma

  def install
    system "cargo", "install", *std_cargo_args(path: "infat-cli")

    bash_completion.install "target/release/infat.bash"
    fish_completion.install "target/release/infat.fish"
    zsh_completion.install "target/release/_infat"
  end

  test do
    output = shell_output("#{bin}/infat set TextEdit --ext txt")
    assert_match "Set .txt", output
  end
end
