class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/messense/cargo-zigbuild"
  url "https://github.com/messense/cargo-zigbuild/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "2fc6775aa9724622aeb63418676c732eb341f253abcb3db9bb11181d1673abbc"
  license "MIT"
  head "https://github.com/messense/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "278b643cc9620375704c82808de46d6634a4f315e7780bdcc58c4a2c971c56b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec8e08f96462df47c2224203ea46f62633e1d315a8019461b79e83f0252ffd8d"
    sha256 cellar: :any_skip_relocation, monterey:       "ab6c5d7b85cf3ef89d668f8c0c1779c708b63c3b92a596b5815f09a4dc324d54"
    sha256 cellar: :any_skip_relocation, big_sur:        "13822761ab5a0f48092e99ca6bfb0cad58ae1feba0b92d909ffbe4460ac2ac04"
    sha256 cellar: :any_skip_relocation, catalina:       "7b45f7e88a137b8f5967018a088b309c051b2760fc59a5abb6a87f9c8c8ab9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "410fd635f3d703f9696402cccd27f49efa390fe45bd20b2eefc38cd21a411c5f"
  end

  depends_on "rustup-init" => :test
  depends_on "rust"
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu.2.17"
    end
  end
end
