class OnecliCli < Formula
  desc "Manage agents, secrets, and configuration from the terminal"
  homepage "https://github.com/onecli/onecli-cli"
  version "1.3.0"
  license "Apache-2.0"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/onecli/onecli-cli/releases/download/v1.3.0/onecli_1.3.0_darwin_arm64.tar.gz"
      sha256 "a969f2b9853b9da143b52a8ad814d1236806a14eddd32c704667750489492912"
    end

    on_intel do
      url "https://github.com/onecli/onecli-cli/releases/download/v1.3.0/onecli_1.3.0_darwin_amd64.tar.gz"
      sha256 "a179cefa1eda018efff58bd159836b65fc8ba4fef82ded8e2d45512004589c94"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/onecli/onecli-cli/releases/download/v1.3.0/onecli_1.3.0_linux_arm64.tar.gz"
      sha256 "399842e85b29844bd6e250f64863b7a219b8b0c3f1c4076503126ba8e8b05856"
    end

    on_intel do
      url "https://github.com/onecli/onecli-cli/releases/download/v1.3.0/onecli_1.3.0_linux_amd64.tar.gz"
      sha256 "d804285a2ec90ae9de430ebd5ee5a07c70cf313a9fd97bde5f112041f3de0e6c"
    end
  end

  def install
    bin.install "onecli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/onecli version")
  end
end
