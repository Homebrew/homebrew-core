class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.9.20.tar.gz"
  sha256 "4e22f05b3586fefcde74b3c24f77e51c3b501c4db9f324cf7abde99fc38e06bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "006879cf055fa856b2d1957511383793b6c9dbf8b46b0a98ac11f0750bb15181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a36f7d1ece1e5bd8f5338685a2d8f8fa6c96aa241d89d593d26a419d788e7802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "082992e7bcaaa9bb5e96ff149e9acd7d77ce94be9fda14e8228f5b0dd64760bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fa7c19d8fb9110ddd15059d5108e714852b17863aa67fc7042bcb6e1565a8be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be40d41bc1e14df5efe3ac4b947402acd8687f5517d3c9f6ca5ae0be9deea632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d69642f96f9c39f1c0670a7c47f1160e180bd49c0cf9071c9083487c94af8aad"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
