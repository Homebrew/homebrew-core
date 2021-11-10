class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "00fe9ae0631d89bce109ac5b8fb3f5ed0e090df1a5fe9e26cc54fa21f0e40710"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66841021e43d87ad1ffa7d48a8cc1d673a7db326ffd5a6c513b3311c7e34e32d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66841021e43d87ad1ffa7d48a8cc1d673a7db326ffd5a6c513b3311c7e34e32d"
    sha256 cellar: :any_skip_relocation, monterey:       "bb1bd388171482baf71c082ee8281f20fd79152f42fd27d4d279279eb0912519"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb1bd388171482baf71c082ee8281f20fd79152f42fd27d4d279279eb0912519"
    sha256 cellar: :any_skip_relocation, catalina:       "bb1bd388171482baf71c082ee8281f20fd79152f42fd27d4d279279eb0912519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079bfc91158a3f91d3260b69d95ab27b892c35b48589584f9b42dc0a60697a89"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
