class GitGrab < Formula
  desc "Clone a git repository into a standard location organised by domain and path"
  homepage "https://github.com/wezm/git-grab"
  url "https://github.com/wezm/git-grab/archive/refs/tags/3.0.0.tar.gz"
  sha256 "542a1e1c1d2a3f1f073e23817bfbab1b98f352f590991e50c6a484177a724b95"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6d259188ace150805463917a5720d983e72210c66e485379d7041c9e3883d640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0c36c3682e20265f64e618b402fcdddd2294c5c4b539dbf4e2e4b4290df60b7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "346664a21b98d75605e66a33e2153205aa74ea192a8ed245b159091a4badba16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96ac1b16e32435e070d1cc16440117a5ca97fcc72e1d7532f9905142bcce4081"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "407ed850f5b4f7ee7b0d575e1013517ecc19333048e59ff5d582b9d828f68134"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d1c34da7030fb7a552beb88a465dcf38064a98c26f217532da0eebf2d8712e5"
    sha256 cellar: :any_skip_relocation, ventura:        "37cbe2aa5d795e7c1befb8ab9fc6a08c7e5e380eb7c304d5d863d4a7e266f1a6"
    sha256 cellar: :any_skip_relocation, monterey:       "eef55e0bd816e04bdd784f4084cf9805e970d4d2d96885e7407a439c750a9a8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9e28a8cc0308a32e07dc37020610380576ad377e8ced36a59197bd7d4bf7145a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "344cd4633b6aaaf7fb4757f6fdd6e51ac88ef2229cc34404a7833a8c3f4568a3"
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
