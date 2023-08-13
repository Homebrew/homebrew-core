class Llama < Formula
  desc "Terminal file manager"
  homepage "https://github.com/antonmedv/llama"
  url "https://github.com/antonmedv/llama/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "606568e098a91c7b0e694534bf0d268d92cc9ac19bce9e4671775837176eb9f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4adfa169cb58477fa07b0f806952d966efa0fb9b22495ab9568a64ad71972f74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4adfa169cb58477fa07b0f806952d966efa0fb9b22495ab9568a64ad71972f74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4adfa169cb58477fa07b0f806952d966efa0fb9b22495ab9568a64ad71972f74"
    sha256 cellar: :any_skip_relocation, ventura:        "7d8baa2669497254cbaf91e4b242bf936ef0f22db3e75cda93bd3e4b2ed957fc"
    sha256 cellar: :any_skip_relocation, monterey:       "7d8baa2669497254cbaf91e4b242bf936ef0f22db3e75cda93bd3e4b2ed957fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d8baa2669497254cbaf91e4b242bf936ef0f22db3e75cda93bd3e4b2ed957fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e9487dcbb9f24e79fd6a0b9655716feba82a9996c470756615d3a6ef29bec1d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"

    PTY.spawn(bin/"llama") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
