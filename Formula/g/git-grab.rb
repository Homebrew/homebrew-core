class GitGrab < Formula
  desc "Clone a git repository into a standard location organised by domain and path"
  homepage "https://codeberg.org/wezm/git-grab"
  url "https://static.crates.io/crates/git-grab/git-grab-4.0.1.crate"
  sha256 "5182ee527d93f15e811d346fb86f3e4c2c24fbc479d4deb57efda6bec065a1c0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ade08cdebf7cc28c45de74e9e06f568a396dbee11c522a9c784c5d8995d8cd7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23aef87925b49840bfa24eb5abaa8d4395239629476e1c3b236488f35996af5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6f92126552067ad40bee28b4077cbf4c3d835b682672e9487a2a7e2e456a9ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "140e815b79aa86d406da070ab5534689d62bf77af1c81e24e7375404bbbb6343"
    sha256 cellar: :any,                 arm64_linux:   "bf01fec43d9b385bbba009258b9851b5b40aa68511290d16feacd857e1877d6a"
    sha256 cellar: :any,                 x86_64_linux:  "ece1be4936c3e4b7c3db70ceb4950de919b0f5448bf2b030a320d13d9d1f39f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "grab", "--home", testpath, "https://codeberg.org/wezm/git-grab.git"
    assert_path_exists testpath/"codeberg.org/wezm/git-grab/Cargo.toml"

    assert_match "git-grab version #{version}", shell_output("#{bin}/git-grab --version")
  end
end
