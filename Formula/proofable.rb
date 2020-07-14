class Proofable < Formula
  desc "Certifying any digital assets (files) to public blockchains"
  homepage "https://docs.proofable.io"
  url "https://github.com/SouthbankSoftware/proofable/archive/v0.2.2.tar.gz"
  sha256 "11e4e76cb2998168e047436fb9ef414b152e1513c80f1ee0d6093da815810c5e"
  license "AGPL-3.0"
  head "https://github.com/SouthbankSoftware/proofable.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f33d9205d669652057599211232a40194a468b143984f97ee4fabb93655ad9f9" => :catalina
  end

  depends_on "go" => :build

  def install
    ENV["APP_VERSION"] = version
    system "make", "build"
    bin.install "proofable-cli"
  end

  test do
    assert_equal "proofable-cli version #{version}", shell_output("#{bin}/proofable-cli --version").strip
  end
end
