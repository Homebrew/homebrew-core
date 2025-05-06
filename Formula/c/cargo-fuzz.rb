class CargoFuzz < Formula
  desc "Command-line helpers for fuzzing"
  homepage "https://rust-fuzz.github.io/book/cargo-fuzz.html"
  url "https://github.com/rust-fuzz/cargo-fuzz/archive/refs/tags/0.12.0.tar.gz"
  sha256 "d7c5a4589b8b5db3d49113e733553c286ed8b50800cbdb327b71a1c1f7c648f0"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a235fde06fab9e783557067a97c7703cdcbe6e8cbca04202c59552807b10aed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d200bc751221a19ccf9146ba1a3f8e4e32a01586a937a509244219771a6b133"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dcb9c76b5715c04e78455be823a80a816d82a57cd2330edba5cd3627727a5ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea92ed46cdb5a202dc759e529514b1d0a0a4b8bce42ce436e4f9137796e8aaef"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6b6e017d751dd370d4f98e16fd3a9fea647ce99e16e71a560bf368271fd10cf"
    sha256 cellar: :any_skip_relocation, ventura:        "098b4b3525481f35a10fdc625f57f08177773a14df00330570f8b97480f41b23"
    sha256 cellar: :any_skip_relocation, monterey:       "291ec71452d89adefcb52625dcf0ba73e1cc041ebb29e0751fd10f585eba9296"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "44ea2bed2e3c5df7e1e9246ea1a741a074d19d6c3e5f02fc5d3cefe9d44100ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "043555cc3d67be54754e137f497d35560a354ccfa357837484ce18a155b976f5"
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

    system "cargo", "init"
    system bin/"cargo-fuzz", "init"
    assert_path_exists testpath/"fuzz/Cargo.toml"
  end
end
