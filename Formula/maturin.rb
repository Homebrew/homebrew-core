class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.8.tar.gz"
  sha256 "f774862c7321aa80c68bb41f0b0e611aa8d75c2fec5d53b24009c7cf9d394e4d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb33dda55fb3e76e3e61ddf7e63335a79b3d7854ff3b677b855e0f6928d0861f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acb3e1266605ecf9c0b90fa655bb24e994c9b23459e92b823aba5efde7229696"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ac2b2d82b4e2248f2d38c274da60a823a8d0a4936c84cd52999551111b590a2"
    sha256 cellar: :any_skip_relocation, ventura:        "8f2d1741f85ca1900ea27804fbf60d92d773f69b2c1f8e945f1ba1dc813863fb"
    sha256 cellar: :any_skip_relocation, monterey:       "9866be2b3074d254d5064c473d21942d7c9bb8d98c6d1eac249a7b4716d804a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d687f3914b343d0e888d11bd3be31c2f60c4a38afd11d8e3b607083e8b0b0021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea1e3f4b3f88cf705e8603d97b9d6a473f0080f8db36f351c1ad70082df024f"
  end

  depends_on "python@3.11" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system python, "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
