class OtcAuth < Formula
  desc "Open Source CLI for the Open Telekom Cloud written in go."
  homepage "https://github.com/iits-consulting/otc-auth"
  version "2.0.0"
  license "MIT"
  defaultHashes = {
  	'v2.0.0_linux_amd64' => "23ba798e7b7da6d0c18fcb6092691255ac70541ec0133c1dd594096090faab48",
	'v2.0.0_darwin_arm64' => "469717f3fe6f207154a00b8a2dfc18fe818e2abb0ab823e2d56f4d1f1268d5fc",
	'v2.0.0_darwin_amd64' => "66e9f621516452201b668773c0ca2195e740e53a7d5c7778daefae5da3e99b24",
	'v2.0.0_windows_386' => "aa7d3b22a546993dc342298155d36d91fc1d5cee5167b85c90b67c5394530f5a",
	'v2.0.0_windows_arm64' => "bef2dbfa03e49fd938c1956b7eaf98b2fa71a642791b1659588ccfcf4f121b8b",
	'v2.0.0_windows_amd64' => "c24ed8b1fc7a789fa566072c85334d3f05d53cccfe2f7c5aa8c904eb8d948ba6",
	'v2.0.0_linux_386' => "e845052892d3f540a9d0ebf59f36365c30f991e05496070071560afe989795c3",
	'v2.0.0_linux_arm64' => "ebc860e9c1eb53cface7cb626e24e18e86f5415ce7069ec9a17289e3226f14a9",
  }

  platform = if OS.mac?
              'darwin'
             elsif OS.linux?
              'linux'
             else
              'windows'
              end

  arch = if Hardware::CPU.intel?
           if Hardware::CPU.is_64_bit?
             'amd64' 
           else
             '386'
           end
         else
             'arm64'
         end

  sha256 defaultHashes["v#{version}_#{platform}_#{arch}"]

  url "https://github.com/iits-consulting/otc-auth/releases/download/v#{version}/otc-auth_#{version}_#{platform}_#{arch}.tar.gz"

  def install
    bin.install "#{name}"  # Install the binary to the "bin" directory
    system "#{bin}/otc-auth", "version"
  end

  test do
    system "#{bin}/otc-auth", "version"
  end
end