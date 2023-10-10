class LaceworkCli < Formula
  VERSION = "v1.33.3".freeze
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  version VERSION
  license "Apache-2.0"

  # Lacework provides prebuilt binaries for all supported platforms
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lacework/go-sdk/releases/download/#{VERSION}/lacework-cli-darwin-arm64.zip"
      sha256 "b6ddc3d2e605f1a2bb2cb4bc38a284f0f1d232a2e45d646f7cbd3f1d9803ef0c"
    else
      url "https://github.com/lacework/go-sdk/releases/download/#{VERSION}/lacework-cli-darwin-amd64.zip"
      sha256 "ce579585bc39b9463e4c2d1608755f233c3ccb953dba9c5c908fe0d570a82a64"
    end
  end
  if OS.linux? && Hardware::CPU.intel? && !Hardware::CPU.is_64_bit?
    url "https://github.com/lacework/go-sdk/releases/download/#{VERSION}/lacework-cli-linux-386.tar.gz"
    sha256 "d53404fb2aa42dfeaa174755d440687a4385dfe6b4c06f54bc89bbe122bdfa61"
  end
  if OS.linux? && Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
    url "https://github.com/lacework/go-sdk/releases/download/#{VERSION}/lacework-cli-linux-amd64.tar.gz"
    sha256 "e1b38581d6ba8ec48c78c1df88f11466968b4b34ae75daba1e2f592212987117"
  end
  if OS.linux? && Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
    url "https://github.com/lacework/go-sdk/releases/download/#{VERSION}/lacework-cli-linux-arm.tar.gz"
    sha256 "723c149da7ad58c8804641389b5f7bee9272fce36f793b159e036e80bf57400a"
  end
  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://github.com/lacework/go-sdk/releases/download/#{VERSION}/lacework-cli-linux-arm64.tar.gz"
    sha256 "d900d603aceab942e9430f05c297618ece40ca24616680a6df136a08534d6c79"
  end


  def install
    prefix.install "lacework"

    (bin/"lacework").write <<~EOS
      #!/bin/bash
      LW_HOMEBREW_INSTALL=1 exec "#{prefix}/lacework" "$@"
    EOS

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match "lacework #{VERSION}", shell_output("#{bin}/lacework version")
  end
end
