class Kiesel < Formula
  desc "JavaScript engine written in Zig"
  homepage "https://kiesel.dev/"
  url "https://codeberg.org/kiesel-js/kiesel/archive/0.3.0.tar.gz"
  sha256 "ead71398e6a6f12266b73492ff2f8e9a8c76b0294ebda71cd0e11e634b4c8273"
  license "MIT"
  head "https://codeberg.org/kiesel-js/kiesel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab2f012efc5b1daa9c673502b625b218dc5e3ef575c7c986866ab38897010cce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "126e96532f3e9f33ceba66842a960de2dac4f3a0d5f3032e700566450cf87333"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5168af6f7c759476d73167b7c6b1f02b8214ccc12107d749f0a2194746651f68"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ebc67b627766de2aee4fcc6b91edbb4e6b370b2c294c7cb10eab6b1382a059f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dcb61f2b0cec39dfe18b4a7bffdc83af7fe3708c970fb2025884865b03f54f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ae2ea0cfd415140f011a0cd134cb8a9b812f2e1b4a8c54c31db9e6b4572ef7"
  end

  depends_on "rust" => :build
  depends_on "zig" => :build

  def install
    system "zig", "build", "-Dversion-string=#{version}", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kiesel --version")

    (testpath/"test.js").write <<~JAVASCRIPT
      Kiesel.print(21 * 2);
    JAVASCRIPT

    assert_match "42", shell_output("#{bin}/kiesel test.js")
  end
end
