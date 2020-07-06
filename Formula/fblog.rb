class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v2.0.1.tar.gz"
  sha256 "36a0dd58be51dda0dec9a87412010f94e4ada9519727c015ae8449dd91140778"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdef753a3f63feb70bcb2a37b14433a65353c83720e3d64131bcaacce17a7590" => :catalina
    sha256 "99c727fc90cfb248e2d667d8906ee312cdbc34bb79fc35bd0f0fbc94e578e241" => :mojave
    sha256 "163b953a575ee872f8c5f7f7c599e33274d3562b4e0202d1332baf279a4a3e8c" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
