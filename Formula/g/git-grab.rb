class GitGrab < Formula
  desc "Clone a git repository into a standard location organised by domain and path"
  homepage "https://github.com/wezm/git-grab"
  url "https://github.com/wezm/git-grab/archive/refs/tags/2.1.0.tar.gz"
  sha256 "ae9edda2d9ff499d2282035e84fa3d5da3776fab1a36e1922dce9584222a196a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5bfd715de505accb3fd4fa4391f12bd447b1120d8bcde3d5714feb8700eb1c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8f42f40deb276a5ad41149c3d0d4f3b9626f09608df9010302747c35eb03095"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5288fb74432bc8b13a6bceb7a6b2dfbbd318e957ba6b8f3151b0a9f83931c54"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3c3a57b9037884e784106e9287e54f60a14e35bd454df4cd91806b7bd4b639e"
    sha256 cellar: :any_skip_relocation, ventura:        "aaf10ce195e13b362d999277e6421a1bd38ac5fb11568885fd2ac8af42c1670e"
    sha256 cellar: :any_skip_relocation, monterey:       "1637bc9e45e61d4639e054767cd46e0f1b50b364f569e872ea90fd702a8fcab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af8ecf6886e9307969f507eaadc0a26fce7760d28141b399b05a8ad0c889122"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "grab", "--home", testpath, "https://github.com/wezm/git-grab.git"
    assert_path_exists testpath/"github.com/wezm/git-grab/Cargo.toml"

    assert_match "git-grab version #{version}", shell_output("#{bin}/git-grab --version")
  end
end
