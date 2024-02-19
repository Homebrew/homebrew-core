class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "8907cff340a91d55704734a14f5c04398dbf5352720c9164ee39e9250c06dfad"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd1d9efdbc84ab6fb661df14add4160b0a02bd8e161e3fad00402ef80241192b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c515bf6ea8dd364b4d2794b5cf4bd942a0dd983b45e96779698c30c7e8304c4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c4607cf9e61e8f6832af3b185ea285d9341ffc1e5c8e5a4304b6691809cf770"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa4ad79f47f79e6d89ffca4dadb460a9088797c93ff8b7d58ed20e701ce48038"
    sha256 cellar: :any_skip_relocation, ventura:        "52f63fc0864cc7ad8178b28537aafe21b03ac8dff16659e475bb1974f67cde67"
    sha256 cellar: :any_skip_relocation, monterey:       "28e5a07f07e57833d549eb0fa4d9bf4d7263b231e7bc6d29a15bc8b0c86162d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e173dc4550e281a7deddc6d4988b490a1f46ccef93a5535c07323328ceb808ad"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Ignore rust installation path check
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    # Remove errant CPATH environment variable for `cargo zigbuild` test
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
