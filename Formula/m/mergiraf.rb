class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.19.0.tar.gz"
  sha256 "b028d1ebfe93c2cefde1a797a44de266044db9b76d5e846f2e40470d2e3f5ab6"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8cf25903a4f9748dc4985050cc6503368a498dab558dad407807a2ba1d5b3d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100a5deaa0b6cc50a4f29c8c30db3f3f2ddc8e98588f094251ca0b276e3cff0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "984337660c41602a3154ff117aea770a1928e96316cef1a897e2740afb7ff9c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8f93a9473db66a26e26fd25bae8c3bee576b02704aa342efe5d7fa4b113c9b5"
    sha256 cellar: :any,                 arm64_linux:   "6bf488a4a57739839a18abad9c728d5169deee60ab1a66ff2332979c7e41aef6"
    sha256 cellar: :any,                 x86_64_linux:  "9b2c251355945a18157d8a54bcb6c42508105734d16445f512d14a3ad6e560c9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end
