class Gox < Formula
  desc "Go cross compile tool"
  homepage "https://github.com/mitchellh/gox"
  url "https://github.com/mitchellh/gox/archive/v1.0.1.tar.gz"
  sha256 "25aab55a4ba75653931be2a2b95e29216b54bd8fecc7931bd416efe49a388229"
  head "https://github.com/mitchellh/gox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6693416aef377d44385c25eb786d25f963258c0895491beedbf6039d7c84c06d" => :catalina
    sha256 "008ec56acef96c3ad3117bcde87f1998fcf4ef9c93f82ae363ed6ac39914a95d" => :mojave
    sha256 "c2d77e6fadb6c7585a5df89eb91aaf1f41f6b88829e1a647efb4ebbc70277b3b" => :high_sierra
    sha256 "1d48879bdbbd84d2406aeaf5f052c51ed2f0b8f9484508ad6085bf537be6f5f6" => :sierra
  end

  depends_on "go"

  resource "iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  # This resource is for the test so doesn't really need to be updated.
  resource "pup" do
    url "https://github.com/ericchiang/pup/archive/v0.4.0.tar.gz"
    sha256 "0d546ab78588e07e1601007772d83795495aa329b19bd1c3cde589ddb1c538b0"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mitchellh/gox").install buildpath.children
    (buildpath/"src/github.com/mitchellh/iochan").install resource("iochan")
    cd "src/github.com/mitchellh/gox" do
      system "go", "build", "-o", bin/"gox"
      prefix.install_metafiles
    end
  end

  test do
    ENV["GOPATH"] = testpath
    (testpath/"src/github.com/ericchiang/pup").install resource("pup")
    cd "src/github.com/ericchiang/pup" do
      output = shell_output("#{bin}/gox -arch amd64 -os darwin -os freebsd")
      assert_match "parallel", output
      assert_predicate Pathname.pwd/"pup_darwin_amd64", :executable?
      assert_predicate Pathname.pwd/"pup_freebsd_amd64", :executable?
      refute_predicate Pathname.pwd/"pup_linux_amd64", :exist?
    end
  end
end
