class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.3.16.tar.gz"
  sha256 "ac040c7b307dac74c44baad797af8790b99a71daf97f1e57c47c858205a21265"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9381048907e393eae9986454f6aae39a43faabfe09baf990da2d8944bee2544b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "101b7ea33ac9e54822aacf7bb1cfe74d12c4b74b4741dc1e6f51ad69e3de1cef"
    sha256 cellar: :any_skip_relocation, monterey:       "d1dac0cdb8f62edbf478a0898d33a7a3bb34a771d7eaa8528d4bebee0e6cda9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0a0aab542985840f8c4c07a4325952a7030c640b71f689c71f84efdc1af1b28"
    sha256 cellar: :any_skip_relocation, catalina:       "1475ff445d397e2453f10036aebc90cab3511b37c521725da21dde4fb23f5ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "995d5cdb3aa4e46d3759ce63eaa2595cab97634a04b577cb333409676604c80e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
