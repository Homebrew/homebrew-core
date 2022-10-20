class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "c66a057df87dda209ecca31d83da7ef04117a923d9bfcc88c0d505b30dabf29b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac6aea1257fc52240d59698d9aece3bac9a0c946f1810d7f765d36ce51e0d813"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "369bc63ae293a9ce8810ff958c461e5bbb70f7183b2a07ca5a9b5fc6ffe8eced"
    sha256 cellar: :any_skip_relocation, monterey:       "c73925014b4ac7a04554d28b1ad7c5e2521e5616af8585d68a579cddcac00aa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "acd90ffcfcb3713c45ee22fc6e3d755958b9b4aeb322e40dac4a1fa17eba1d68"
    sha256 cellar: :any_skip_relocation, catalina:       "73486d1c7cfc81d58b5433b132ce89e4221358451d2bb6bfe817c83111b7ea03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86534c4ac773cf0cbba917dadcb54e74c39478607403032f877d9cd9271793d4"
  end

  depends_on "rust" => [:build, :test]

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "./cargo-crev")
  end

  test do
    system "cargo", "crev", "config", "dir"
  end
end
