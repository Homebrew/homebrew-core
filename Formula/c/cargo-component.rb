class CargoComponent < Formula
  desc "Create WebAssembly components based on the component model proposal"
  homepage "https://github.com/bytecodealliance/cargo-component"
  url "https://github.com/bytecodealliance/cargo-component/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "04ded8443b34687641d0bf01fa682ce46c1a9300af3f13ea5cf1bf5487d6f8b1"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/cargo-component.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3497716750d824a4bdf9a76887a0bf65d91f2e3cdea5cee1e61db5eeafb0dff1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "365e0a9252cbc901b8fc5b7185c36856710c2b6f2c61d5be3f4e2e7fad810644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c25f9379640918aacf3a212b2c179de5c95e13036b1101bfb38447d3b5c8807f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8019d3e73441d400669124df50da4f6a201de87cee09a6a7192da9b5f46b24d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4004c115656b6d5d315e44b71d107bfd34653691c4b7fd033ccaabe8f9672542"
    sha256 cellar: :any_skip_relocation, ventura:       "498e8317e9c2a8dc95fae4fbcf42d4e35a2e9c238b8b204f3647e909d96771e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f75abc0af44a9a0dba2987bbc1abf62c6279b4422d6988de72e564937520436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9294cc2f428022db86233513bf8f3712a0c3beaf4f16985aaf81199f82a1d19a"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "component", "new", "--lib", "brew-test"
    assert_path_exists testpath/"brew-test/wit/world.wit"
  end
end
