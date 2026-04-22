class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.25.tar.gz"
  sha256 "8524bb030a5549b790d56ce687b4af5e50131faac0b89975ad077b3875bb0296"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bdebd33b1f6152565900d5a6425bae13485f9323938657c2663040b83e58532"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14e2905bf91d3cff0105ac5f65d15ea61250d327e21302d300d7c192f1eb51d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d22c78262bbfce105a9306c62de2756107a5cf61671275ef8ea76180e68d214c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ac3e69ccb92185db10558fdce3f4ec1450022d0f3f786ca32c7819fa090dfd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "083d0f30f4b28b63e0714d21aac8e2a8d849ec81c58883310c4a95ec0bb30934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb73bbbb2f0182d0b0d8ec6cd63ddf63f439df702d4cf6f96d82dd2775821b3"
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
