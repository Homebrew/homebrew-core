class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "4bc726abe474033408f01b0f5cc488de1b3211836a5bec9446c6fa8a431d72c0"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "227be5037ae76ad5beff96037a0bb8d2609bb1519e7f090d8696631b240a55a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "97e56606b503a06d454bf8407df52607442717a8c018e8c92474badea26b297e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6b09df02b30f3f962c482f014f71d8dfb7820e94b3410d926782fd9114980ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dcac066ddc4459e6665812f077e8b45e5655977bc4e308c85a3d15b4dc73c548"
    sha256 cellar: :any,                 x86_64_linux:      "4b541778bb58e8d14b9b6f20acdc16efe7725a3e2db7c5222645505f60d89fdf"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
