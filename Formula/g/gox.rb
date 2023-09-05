class Gox < Formula
  desc "Go cross compile tool"
  homepage "https://github.com/mitchellh/gox"
  url "https://github.com/mitchellh/gox/archive/v1.0.1.tar.gz"
  sha256 "25aab55a4ba75653931be2a2b95e29216b54bd8fecc7931bd416efe49a388229"
  license "MPL-2.0"
  head "https://github.com/mitchellh/gox.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc3541078d72a1444271a84d0ab43b61a21a4cdd4abdbaca8c221875f3711056"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0ca344c6ffbd3aadec83b8cd9368048f0dc69e8315e48cb153fc7a9854a81fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "943375b71098b9de0d440507638f5e514cd09ec8a4b99d628f2a7d687786f3a9"
    sha256 cellar: :any_skip_relocation, ventura:        "fe5adf29a3549afb24073146789815be755280eaa7353dc447deaf6d45d75107"
    sha256 cellar: :any_skip_relocation, monterey:       "44fa2d97c954b779d00438141555cbb7550efac06b9eb805511a040927d6e956"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a1967d492f5b586399d6fa9fa0b9f461e1178563625c1ea23e62fefbf384d36"
    sha256 cellar: :any_skip_relocation, catalina:       "3cd12726dcdcf4e41a87d00825f7e5a915252e12c13dfe7a88efecba63a2dc6d"
    sha256 cellar: :any_skip_relocation, mojave:         "79355b0248170797677b7e202fb6a071fc59fa087eef025c3aa4868e65edd6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cc3c2783e83ca2b0d77c516144d4311df5f4a04ab445b5175e9d2585f8a3e3d"
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
