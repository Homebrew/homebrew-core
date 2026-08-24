class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "a315a38f0598554998e7b256d4ef997d158592532d43ca52328c8dc8e177d65f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8b31ab9a4cbd7c368af50fbb687f6556d5af0e40b37ee410ba64a4ac91834c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df8aa2bd3a487842861c640ed0a8e2d739c8f26d7569379ffebd10d0c4ff6806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a27e0dd2589f2dcdfcd1c51662c13033264e9dc21f7f060432165dd3c5065eac"
    sha256 cellar: :any_skip_relocation, sonoma:        "7161ba0470e1326e64fed5e056cd0366df8028dea56d912d84065eeb089fdd1d"
    sha256 cellar: :any,                 arm64_linux:   "9afad88db2b69057b943e7d5891974b25d9cbe09bdd98628604cc9ec9eb83fbb"
    sha256 cellar: :any,                 x86_64_linux:  "068bb5270ce30bb812756e73105f40bfa17e2e0e3560d748cd0ce46d889ae9dc"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
