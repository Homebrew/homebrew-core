class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.5.3.tar.gz"
  sha256 "cc4608a63813ae8322b21219723bab37edd91a8fcd7ce9810876f4d688eaa1dc"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "911eb1ca9babcea29286f8ee235a6f785a34dea9d43ac44684663a487eb3d775" => :big_sur
    sha256 "f09b033edff11fcd8c1c3116ebe4d6bffe398985bd03210a92142cb7f6d1b7dd" => :arm64_big_sur
    sha256 "2c7a65e0e04b84106700c9228739c4e1f8e7939b66f5770819db0c044ed3b60f" => :catalina
    sha256 "3ba9898e75191e458e9da01dcbe835aefd82b167e7a2af2ab02a1fdfbbd7f8f8" => :mojave
    sha256 "63db59c2436d167b2c6315ed23ad9e3e2d814d37b3e0460d4ac53c7608f99dbf" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
