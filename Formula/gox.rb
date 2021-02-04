class Gox < Formula
  desc "Go cross compile tool"
  homepage "https://github.com/mitchellh/gox"
  url "https://github.com/mitchellh/gox/archive/v1.0.1.tar.gz"
  sha256 "25aab55a4ba75653931be2a2b95e29216b54bd8fecc7931bd416efe49a388229"
  license "MPL-2.0"
  head "https://github.com/mitchellh/gox.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:  "ee0ae4811c2bd84db661328bda7ff64e3560aae5bea9b9447dc75f0c4528ea03"
    sha256 cellar: :any_skip_relocation, catalina: "0faf261981e71df491ffe35d995aeefe1660bf73c204206ad88668981882e88e"
    sha256 cellar: :any_skip_relocation, mojave:   "96cf3f477de802c91e532a362cfaab221854f8683414b0abecbbe1e4b66c6b56"
  end

  depends_on "go"

  resource "iochan" do
    url "https://github.com/mitchellh/iochan.git",
        revision: "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  # This resource is for the test so doesn't really need to be updated.
  resource "pup" do
    url "https://github.com/ericchiang/pup/archive/v0.4.0.tar.gz"
    sha256 "0d546ab78588e07e1601007772d83795495aa329b19bd1c3cde589ddb1c538b0"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    ENV["GOPATH"] = testpath
    ENV["GO111MODULE"] = "auto"
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
