class Crc < Formula
  desc "OpenShift 4 cluster on your local machine"
  homepage "https://code-ready.github.io/crc/"
  url "https://github.com/code-ready/crc.git",
      :tag      => "1.7.0",
      :revision => "fa7e55872ba336258d503fc54ed2a4bb194ebb99"
  head "https://github.com/code-ready/crc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "007777ac043b06fc75d74401119316705139eb876048eb914507e216b3c1d893" => :catalina
    sha256 "4811de8b2aa52a8c14c2005bdb39ffb49ef0acad0c8acbeaf6d3685258d72609" => :mojave
    sha256 "57cf9f856d4ae5859586b975a7eea06a807027dafb2852dd5464822a9b64081f" => :high_sierra
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
