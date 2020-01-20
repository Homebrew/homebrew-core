class Hey < Formula
  desc "HTTP load generator, ApacheBench (ab) replacement"
  homepage "https://github.com/rakyll/hey"
  url "https://github.com/rakyll/hey.git",
    :tag      => "v0.1.3",
    :revision => "36f181ad99713ffd70c09a021ea8a689b8fb43d3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cd9a8e4d509b49c316adf3e3a81a803013ee16aef60c5764f8d630320c8d8de1" => :catalina
    sha256 "b3679713758e81df3b8a269bd16c21a02826f559e87b36ed23a8184013929afa" => :mojave
    sha256 "a935a6112c86b4a42b53f1d914ddb1719529ff2c0fb72a1c92be432fa9bf974b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"hey"
    prefix.install_metafiles
  end

  test do
    output = "[200]	200 responses"
    assert_match output.to_s, shell_output("#{bin}/hey https://google.com")
  end
end
