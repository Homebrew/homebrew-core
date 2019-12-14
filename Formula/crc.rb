class Crc < Formula
  desc "OpenShift 4 cluster on your local machine"
  homepage "https://code-ready.github.io/crc/"
  url "https://github.com/code-ready/crc.git",
      :tag      => "1.3.0",
      :revision => "648b3520011f493a1f420196dffb4709d60a7479"
  head "https://github.com/code-ready/crc.git"

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
