class Crc < Formula
  desc "OpenShift 4 cluster on your local machine"
  homepage "https://code-ready.github.io/crc/"
  url "https://github.com/code-ready/crc.git",
      :tag      => "1.8.0",
      :revision => "0a318dc9335a1e7cc24c5b19b5aa383ec619f9c4"
  head "https://github.com/code-ready/crc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "675da55a1ddf26a168a4030266b2dcb076070ce08cd747269e3923a598a1d912" => :catalina
    sha256 "65491ed4b9337c19900964a69b3328311f4ee4038e2aeeff7d3d243ef995c3ed" => :mojave
    sha256 "5586c571b03bff47b51d23d13d8850ba263f375471c3e1cc4eb2c0d77ca74bdf" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "out/macos-amd64/crc"
    bin.install "out/macos-amd64/crc"
  end

  test do
    assert_match /^crc version: #{version}/, shell_output("#{bin}/crc version")

    # Should error out as running crc requires root
    status_output = shell_output("#{bin}/crc setup 2>&1", 1)
    assert_match "Unable to set ownership", status_output
  end
end
