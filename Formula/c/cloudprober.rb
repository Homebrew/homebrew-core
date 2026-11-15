class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.14.7.tar.gz"
  sha256 "ea4d84380546b761270d88c46c109002b96e93c609048f599f21c9f77dc77fad"
  license "Apache-2.0"
  head "https://github.com/cloudprober/cloudprober.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "546ee137c4f3d9e2feb5599050b52a357821f6d494d0064b20020ec4dbb7df0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d9ca03454c49981d0ede0b1e4bf332213cbfa0fef7be80a6c2da9717e1de7fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1bb8980fb89da4ac04dd58eec65bf7bfba0dec7db92fd1b8e5b5d36f69abcb90"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "09f749317505f925bd6e740f8e39ad1fe40c04f650ca8ed5b07e9a07c2e1af3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "03c751e42222bf5a02aa8440cff13f00dc8db3255a1f7b0e81c04f6fe34127fc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
