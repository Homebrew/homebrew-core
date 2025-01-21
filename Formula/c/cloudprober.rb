class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.13.8.tar.gz"
  sha256 "96abe8cd6f48a8e4206e818447070369ccaa2ca68dc1ff8b244a7df4dc0af742"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c315ff61ccc03a0075d7e67d36032c9903f75b469c9c4b3cbf21620831482926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "107c78a6a6beef8a55314b5051616d8e1ec6e65419621754a9fae95c74f4eabe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb48b91f808f2232771f934d3eef0e071084bcde1339bcf728ced7e228a28297"
    sha256 cellar: :any_skip_relocation, sonoma:        "40b73304ff5c2ee7230878f631a428cfaba642f59f86c53ded6f97ba44858351"
    sha256 cellar: :any_skip_relocation, ventura:       "55cd7174f2bb06615006684f2848ed2be4d60ebbedab57bee4bf1930fff3399d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b5dea36136024ebd52a37608bf9b5e46eb571cb8c78edb3eb3903b0d0cdf37d"
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
