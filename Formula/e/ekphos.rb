class Ekphos < Formula
  desc "Terminal-based markdown research tool inspired by Obsidian"
  homepage "https://ekphos.xyz"
  url "https://github.com/hanebox/ekphos/archive/refs/tags/v0.20.10.tar.gz"
  sha256 "536d19bc93c2404bcb031b595e68012a5f369e400157b0637824b9c8b443da5b"
  license "MIT"
  head "https://github.com/hanebox/ekphos.git", branch: "release"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccf301529373a873b634deb8f5afc01c61a06ddb8140e2a62cc4074cf7d2f7ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67e03426e9a9619f9136556b92350f9fc08eb42bdaa931ea52801669a15a5be2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c9c00694d5272bc33e6a378baa92a75a343c712f0f87aafdd06da7429f6416b"
    sha256 cellar: :any_skip_relocation, sonoma:        "43f8e742cac3b608e60377ca7d59705d5cf1e7f85240abd44234290665fba439"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca64eb1e1443d052a3241b1b2a4703407b811d90c397f3ce4d14912538945896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d779ad9e4f45e1c708a0e72be365ee7ddd5a9cb824c7565e45fa81a20a861f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ekphos is a TUI application
    assert_match version.to_s, shell_output("#{bin}/ekphos --version")

    assert_match "Resetting ekphos configuration...", shell_output("#{bin}/ekphos --reset")
  end
end
