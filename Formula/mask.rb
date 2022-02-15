class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jakedeichert/mask/"
  url "https://github.com/jakedeichert/mask/archive/v0.11.1.tar.gz"
  sha256 "49de25ee23bfa2f04f09750cf9b223a8ff5024280dca4ea40893e53212bef0b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "642f6b33ca9fb556b0e25c639c0b0b72bd577c16b38abc7aacb0186b06a5e6a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a8d12727a7304ab91f1efff0a936d0749ced7b93a23d95341f2d1bb4eb7fe50"
    sha256 cellar: :any_skip_relocation, monterey:       "9f94a81fb949d160b9b08c21ee23ddea7003cb7e1203f91f7147c5b910e00e6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "feb8ceded3fb6fa99b2660eb22a649f7ec13ee72dacc3cb71c82b43688685d8e"
    sha256 cellar: :any_skip_relocation, catalina:       "cc2cb845008b7772b2bd9f87cba495a5ed7702b7a5fc67ba4d79992e278e5cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfe51d1fbb5949917a95262d8ebb2fba5448676e9349ae27297abeb0721e39a0"
  end

  depends_on "rust" => :build

  def install
    cd "mask" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"maskfile.md").write <<~EOS
      # Example maskfile

      ## hello (name)

      ```sh
      printf "Hello %s!" "$name"
      ```
    EOS
    assert_equal "Hello Homebrew!", shell_output("#{bin}/mask hello Homebrew")
  end
end
