class Msedit < Formula
  desc "Simple text editor with clickable interface"
  homepage "https://github.com/microsoft/edit"
  url "https://github.com/microsoft/edit/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "41c719b08212fa4ab6e434a53242b2718ba313e8d24d090f244bb857d6a9d0fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "300de72b71a69bf416777351c3f771cd8f965581ca38933dab0b5f137c99115b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a609fc4363c7917cc775e1d343ca2e9f010dca3fd61d721b15ef26cb5533901e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a33cf49751e560b1dfbcc926e3b5ff70c01891acbd11cb582dc7f3ce1cb03473"
    sha256 cellar: :any_skip_relocation, sonoma:        "776afb0bf80f2fbf1629d631cd8eb637c0996e5ca96f5d5e738c9d4f016fa148"
  end

  depends_on "rust" => :build
  depends_on :macos # due to test failure on linux

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    # msedit is a TUI application
    assert_match version.to_s, shell_output("#{bin}/edit --version")
  end
end
