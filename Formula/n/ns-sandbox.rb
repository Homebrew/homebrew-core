class NsSandbox < Formula
  desc "Cross-platform command-line ns-sandbox"
  homepage "https://github.com/navysummer/ns-sandbox"
  version "0.0.1"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/navysummer/ns-sandbox/releases/download/v0.0.1/ns-sandbox-#{version}-x86_64.tar.gz"
      sha256 "9c37892e94909f6bd39a79fd3bc4f785b31be9d1bc3691bc23ba06ab7a6beb96"
    end
    on_arm do
      url "https://github.com/navysummer/ns-sandbox/releases/download/v0.0.1/ns-sandbox-#{version}-arm64.tar.gz"
      sha256 "5a31dafa76824e5725751793317e2b9a8643b2760eb656c8e6d9e1e5b8715222"
    end
  end

  def install
    bin.install "ns-sandbox"
  end

  test do
    system "bin/ns-sandbox", "--version"
  end
end
