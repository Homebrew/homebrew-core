class FlipLink < Formula
  desc "Adds zero-cost stack overflow protection to your embedded programs"
  homepage "https://github.com/knurling-rs/flip-link"
  url "https://github.com/knurling-rs/flip-link/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "3608b9adddd5415d1a897947abaaf0438a8a4459292054dc7eb1f809ecab1366"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea90aef07c426e04b66ea2397ce1e2e22dabc52774f2d50d8015ec46978cfdb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b05e6b93858ca017be251d2446d44ac72fda26bc824bedbd8e5ee31837f4e858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de05d8304554048228f668c60e1d5f32a2420f00ed0105794e835f44b96c03a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4a0f0f6b8b85fd41b9bd566485650607d9a4e283300235917549e7194f187f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94c40029460a66e8e343f1a073361a7bfe46b598d820000797dc6040c45f53ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52890212a0445ce719f608eab616fa430de53469eb3134c0ff4906eab2f5566c"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
    (pkgshare/"examples").install "test-flip-link-app"
  end

  test do
    # Don't apply RUSTFLAGS when building firmware
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "rustup", "target", "add", "thumbv7em-none-eabi"

    cp_r pkgshare/"examples/test-flip-link-app", testpath

    cd "test-flip-link-app" do
      system "cargo", "build"
    end
  end
end
