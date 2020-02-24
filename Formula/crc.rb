class Crc < Formula
  desc "OpenShift 4 cluster on your local machine"
  homepage "https://code-ready.github.io/crc/"
  url "https://github.com/code-ready/crc.git",
      :tag      => "1.6.0",
      :revision => "8ef676f90f9be7c0ba4dceb27a29ec04dee5650d"
  head "https://github.com/code-ready/crc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1cbd0162d99bad01ddb68ec74c4672635da35be0637a01c9334facbd2bc80f3" => :catalina
    sha256 "42a0f12a5aae455cd5c6d8dadbddc930dc54b8ea14693f7a7c9a2952978cf717" => :mojave
    sha256 "7f5fef96248a517547beeb9d6ebe1477745f0865165c0ab7cd10a7c6aef4f00a" => :high_sierra
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
