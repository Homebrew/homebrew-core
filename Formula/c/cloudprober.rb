class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.13.9.tar.gz"
  sha256 "8234531b82c6e2a8886321ac8566bc87a2ee86c48b3545d57202561afd7a03d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cf5c6f6f12db734e7cd8024e74ab9d071e8a466dbb0fa7c3d4bad9727190c54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9f1d2a610b06ed58c9a252857bb94c04abc5d1577eba51f8103f7ce48c8feee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2d7c0a27c62f762597e7ea5ad9dcbe52cd8a07be96cd9e9833be33b1f7f8dd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "89feaefcc0751eb1d293e7e843ea98920578bf7390595f3395c98ecc87164edf"
    sha256 cellar: :any_skip_relocation, ventura:       "4736851d3ac03f3f75cb003705d71866d14bcd28afba6c67d748f9970726c475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aac763b3c1e83b806c9686a47cb97f7160f94a62896ee8e466d7c617e8fc8edc"
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
