class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.23.11.tar.gz"
  sha256 "c8ddfaa3790d10a0e6a8ce1cf2defc967646f02d90983c3e85c4b635b6fa5c34"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9aa0c5308e5cd2aa7a74b9f579d9e96a87d80d5b94d57b7ce17f3182e9bb4d05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aa0c5308e5cd2aa7a74b9f579d9e96a87d80d5b94d57b7ce17f3182e9bb4d05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aa0c5308e5cd2aa7a74b9f579d9e96a87d80d5b94d57b7ce17f3182e9bb4d05"
    sha256 cellar: :any_skip_relocation, sonoma:         "c902ee4689b699a9dfa262da72d400aec6ef03860fd4139a1ef984ca0381554d"
    sha256 cellar: :any_skip_relocation, ventura:        "c902ee4689b699a9dfa262da72d400aec6ef03860fd4139a1ef984ca0381554d"
    sha256 cellar: :any_skip_relocation, monterey:       "c902ee4689b699a9dfa262da72d400aec6ef03860fd4139a1ef984ca0381554d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fc2236fd138c49d53ab759bc0711ae0bbc2fefefbaafb789fb2214531dbb9bf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
