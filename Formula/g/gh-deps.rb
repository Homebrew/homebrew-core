class GhDeps < Formula
  desc "Search for repositories that use a specific library"
  homepage "https://github.com/yoppyDev/gh-deps"
  version "1.0.3"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/yoppyDev/gh-deps/releases/download/v1.0.3/gh-deps_Darwin_x86_64.tar.gz"
      sha256 "70a92bbed77eeb84b2861ea4e59e95a7c7e018e63a9c339c400abeaeaa2eea7d"

      def install
        bin.install "gh-deps"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/yoppyDev/gh-deps/releases/download/v1.0.3/gh-deps_Darwin_arm64.tar.gz"
      sha256 "e66f20bb6df82407278edcd81282592e5dc5decd4428c06d65ed218fab0a5afa"

      def install
        bin.install "gh-deps"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/yoppyDev/gh-deps/releases/download/v1.0.3/gh-deps_Linux_arm64.tar.gz"
      sha256 "7fc4c278a7745827525a50a265c35fe95de86c2e5329e9d9046e50ab46044027"

      def install
        bin.install "gh-deps"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/yoppyDev/gh-deps/releases/download/v1.0.3/gh-deps_Linux_x86_64.tar.gz"
      sha256 "1a03967ed4bc5da7236b46a6793bba38ef0e4d1913c46407796738d03532b1f6"

      def install
        bin.install "gh-deps"
      end
    end
  end

  test do
    system "#{bin}/goreleaser -v"
  end
end
