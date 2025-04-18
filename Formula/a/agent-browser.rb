class AgentBrowser < Formula
  desc "Navigate the agentic web with agent-browser"
  homepage "https://github.com/co-browser/agent-browser"
  version "1.3.2"
  license "MIT"

  on_macos do
    on_intel do
      url "https://storage.googleapis.com/cobrowser-images/agent-browser-v1.3.2-darwin-amd64.tar.gz"
      sha256 "3078c6bf4de631b8356430d3fc8e917f2c39e35a0a04ce4db65ff6c54d716a51"

      def install
        bin.install "agent-browser"
      end
    end
    on_arm do
      url "https://storage.googleapis.com/cobrowser-images/agent-browser-v1.3.2-darwin-arm64.tar.gz"
      sha256 "198dddbcd5c5ea2f00bc4e5ed59a1d20a8d073526fa1b15b1161aef3d743485c"

      def install
        bin.install "agent-browser"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://storage.googleapis.com/cobrowser-images/agent-browser-v1.3.2-linux-amd64.tar.gz"
      sha256 "9aa9f8a19a68df141c135b7c2024e085faddf2395ab3336d6bb4292a78454d95"

      def install
        bin.install "agent-browser"
      end
    end
    if on_arm? && Hardware::CPU.is_64_bit?
      url "https://storage.googleapis.com/cobrowser-images/agent-browser-v1.3.2-linux-arm64.tar.gz"
      sha256 "f7d38f25cd858557c934f108e55f78dacbffbb1af9b84c78102929945d64d766"

      def install
        bin.install "agent-browser"
      end
    end
  end
  test do
    system bin/"agent-browser", "--help"
  end
end
