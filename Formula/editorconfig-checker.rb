class EditorconfigChecker < Formula
  desc "A tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  version "2.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/editorconfig-checker/editorconfig-checker/releases/download/2.5.0/ec-darwin-amd64.tar.gz"
      sha256 "8167e4d6eb1d0f5979a050ed54415f6d162aaa11989a171ebc880308dea2c382"

      def install
        bin.install "ec-darwin-amd64" => "editorconfig-checker"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/editorconfig-checker/editorconfig-checker/releases/download/2.5.0/ec-darwin-arm64.tar.gz"
      sha256 "2691bcc2a99198a7d63fd42c35628024814457a3c334ed11d2bf3c2bf1f8bb33"

      def install
        bin.install "ec-darwin-arm64" => "editorconfig-checker"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/editorconfig-checker/editorconfig-checker/releases/download/2.5.0/ec-linux-amd64.tar.gz"
      sha256 "3cff2e9f4f4a3bd67b5861bab6082a360bb03f8f098ef76304d5ec018f089a08"

      def install
        bin.install "ec-linux-amd64" => "editorconfig-checker"
      end
    end
    if Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
      url "https://github.com/editorconfig-checker/editorconfig-checker/releases/download/2.5.0/ec-linux-arm.tar.gz"
      sha256 "206873e77d35ba71d788f867c9139e75cf0f71886fc67e752bfe1c70f9e18027"

      def install
        bin.install "ec-linux-arm" => "editorconfig-checker"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/editorconfig-checker/editorconfig-checker/releases/download/2.5.0/ec-linux-arm64.tar.gz"
      sha256 "28d156c800a66f98641c444cbcc50845f20140265c8da55d543bcc4ab7b817b9"

      def install
        bin.install "ec-linux-arm64" => "editorconfig-checker"
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
