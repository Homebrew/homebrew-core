class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.23.tar.gz"
  sha256 "38d74be24e527aa9870f7f46e0d52699a5ec09c608288deb26e8e46054f9fecb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a012f21f80be964ffe1fc218700c368af748615a8ce17a078bf43bdfa1174f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a132a52b1f5d0d0b8912949275c6c2eb7943153ccfaf3741ef44103a892dab04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6c2523b25dc0c4bb131f93c7f2d5232fe7fc43e83c0aaa799bc85be5198bb33"
    sha256 cellar: :any_skip_relocation, sonoma:        "51dba55bbb8f34190033512c88be44a8d7e3a8e828abd901f2b2583a8149fea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a7825fa8cf2e57a0e889722339814daf80fae4bd574e5972fbffdda3dc7dd1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c7d91e63726284e7db1c0b48fab4f2bd6c1d405ac6835f05113577df9aa3861"
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
