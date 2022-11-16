class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.14.0",
      revision: "300bbc868ba8f2c15b35e09df7e8804753cac00d"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08dd84f470df1010345ea9ec2ddede00589363ddb7a607db1541c75cbf98d61a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "139570603e519b01b9591ac7e71b46ee310fb34a8430fae248938232b70d747e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "139570603e519b01b9591ac7e71b46ee310fb34a8430fae248938232b70d747e"
    sha256 cellar: :any_skip_relocation, ventura:        "b21fa8f11d85d2541dc18c42fa1515592313c73bb074ac61df4501aa297f18a3"
    sha256 cellar: :any_skip_relocation, monterey:       "c96d1ce7372a0cc6df4904089c12e7850013bb2f704da4d01ae3f35dc61b03e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c96d1ce7372a0cc6df4904089c12e7850013bb2f704da4d01ae3f35dc61b03e2"
    sha256 cellar: :any_skip_relocation, catalina:       "c96d1ce7372a0cc6df4904089c12e7850013bb2f704da4d01ae3f35dc61b03e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d61f0354d32fd0ea74f416150d26eb2df2c0f715d59f19c695e069ad4e7d3752"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{time.rfc3339}
      -X github.com/magefile/mage/mage.commitHash=#{Utils.git_short_head}
      -X github.com/magefile/mage/mage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_predicate testpath/"magefile.go", :exist?
  end
end
