class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "69200ae4bc99ba41c5a884af6491373cf9cfc5cd66590804c6254460951da968"
  license "MIT"
  head "https://github.com/edoardottt/csprecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d107562498b42b0e1b90be7b20e5cce58e36e722aabaeed906478642b8f344b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d107562498b42b0e1b90be7b20e5cce58e36e722aabaeed906478642b8f344b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d107562498b42b0e1b90be7b20e5cce58e36e722aabaeed906478642b8f344b"
    sha256 cellar: :any_skip_relocation, sonoma:        "02fe59829e752d8f022020ef1e4cd105da7c791e8f58c1588e55d0fda1ccf02c"
    sha256 cellar: :any_skip_relocation, ventura:       "02fe59829e752d8f022020ef1e4cd105da7c791e8f58c1588e55d0fda1ccf02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c58fc8a2225d8fb674e45f69015becdbdee1d4af13050b1837b1f26c6dbade70"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/csprecon"
  end

  test do
    output = shell_output("#{bin}/csprecon -u https://brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end
