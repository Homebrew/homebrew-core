class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.5.1.tar.gz"
  sha256 "feafbb1d2515bd5dd80b6408d6611549ea22c4366687883b92f706dfd2df596a"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc9040e7b5b6afbe799b3d145e60270340a3e4336958b377c7807d881c41ea0e" => :catalina
    sha256 "623f8a3f8e7d0a3189176be593b635d24329300ee0c424f5004a3835325ebc9c" => :mojave
    sha256 "a5523fec056236e5d6fc5e738e068c8d219c69ec45915e7fca4aad474358ca03" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"berglas"
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
