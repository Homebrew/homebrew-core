class Granted < Formula
  desc "The easiest way to access your cloud."
  homepage "https://granted.dev/"
  version "0.38.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://releases.commonfate.io/granted/v0.38.0/granted_0.38.0_darwin_x86_64.tar.gz", using: CurlDownloadStrategy
      sha256 "3f7a4649ad3ac6636555a3902eb5876acdc6c93be8be14a5a3a2368e2384f8c9"

      def install
        bin.install "granted"
        bin.install_symlink "granted" => "assumego"
        bin.install "assume"
        bin.install "assume.fish"
      end
    end
    on_arm do
      url "https://releases.commonfate.io/granted/v0.38.0/granted_0.38.0_darwin_arm64.tar.gz", using: CurlDownloadStrategy
      sha256 "cfab086d85baa4177060391d94b6d61ae141dc67659eb7e803ecee4ae4789cf6"

      def install
        bin.install "granted"
        bin.install_symlink "granted" => "assumego"
        bin.install "assume"
        bin.install "assume.fish"
      end
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://releases.commonfate.io/granted/v0.38.0/granted_0.38.0_linux_x86_64.tar.gz", using: CurlDownloadStrategy
        sha256 "2547cc521f1c932b32d0132b8fd82f43d1880f53a457b17b58b2f27711ed20bc"

        def install
          bin.install "granted"
          bin.install_symlink "granted" => "assumego"
          bin.install "assume"
          bin.install "assume.fish"
        end
      end
    end
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://releases.commonfate.io/granted/v0.38.0/granted_0.38.0_linux_arm64.tar.gz", using: CurlDownloadStrategy
        sha256 "3c27a5740cdcd2b414a70b90cc381eb57323128401e9705ae8587f6df8f8e633"

        def install
          bin.install "granted"
          bin.install_symlink "granted" => "assumego"
          bin.install "assume"
          bin.install "assume.fish"
        end
      end
    end
  end
end