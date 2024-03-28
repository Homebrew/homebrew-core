class GitGrab < Formula
  desc "Clone a git repository into a standard location organised by domain and path"
  homepage "https://github.com/wezm/git-grab"
  url "https://github.com/wezm/git-grab/archive/refs/tags/2.1.0.tar.gz"
  sha256 "ae9edda2d9ff499d2282035e84fa3d5da3776fab1a36e1922dce9584222a196a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "daa673aa92ebb4808c7982072bec40f59b14fd8fc935ce55e3ce5e012ff12644"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8db21a161b6f07a47f03c75173ff5e232ec1c8b544c72126b68fbaee7eeea3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec1360d562d526748f473ea6a026afc4155fbf60b83a7a40a61cb383b56aa22a"
    sha256 cellar: :any_skip_relocation, sonoma:         "09437f46b8c75339abb701f33b5b8633f1cf158a20f93c513bd0ce3b58d7a7f9"
    sha256 cellar: :any_skip_relocation, ventura:        "8e55370245d0af44d8538c048c8e0c968c02f5c622e4a61a6aab360b0a6090d1"
    sha256 cellar: :any_skip_relocation, monterey:       "118b5ca8f2eb208d63bf2e9bf0027fe840b2a52d251b123e8e0ddc6c334e5528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07ad27bcb3b9c65082e05869e40aa61b70dbedeb21d5bc8b94283d21b00a29bf"
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
