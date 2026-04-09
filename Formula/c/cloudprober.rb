class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "7e5b208299b5c4eda0d696238830d28e042f6939dc8f18bb631aa825bf2c3ea6"
  license "Apache-2.0"
  head "https://github.com/cloudprober/cloudprober.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bb3c79ba7790da39fa1df0d831e1467ead8e9ee4eda8b2c70e35f7481552861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba4cc71cb9101b53a37ab6fd77e5b0dbb95a2b0ff1f92475b66cfe7731bcfbe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cf19e3fad979aa21102af334fb2bcf205034537e4e0e099a224c9eb353d1f2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6790a0a2d3ef1e3b096fe95617bf4e5c326419eb3b43a985c6a3d00cf634aeef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18839777a703e4c28158853392a388d6b7c42fa52f1ccb212c90c7d6f52cf1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca329a4ddbe964c97ef98507c1970afc9e44033ff6cf33c008d082cc3d06b384"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      line.include?("Initialized status surfacer")
    end
  end
end
