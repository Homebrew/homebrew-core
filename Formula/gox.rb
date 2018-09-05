class Gox < Formula
  desc "Go cross compile tool"
  homepage "https://github.com/mitchellh/gox"
  url "https://github.com/mitchellh/gox/archive/v0.4.0.tar.gz"
  sha256 "2df7439e9901877685ff4e6377de863c3c2ec4cde43d0ca631ff65d1b64774ad"
  head "https://github.com/mitchellh/gox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcae7995f2a767bfad7e51926e5bdf1706c6e289870b7bea71b9d7e48728c244" => :mojave
    sha256 "ce011971b907d6924b60ea48d2beafea504d9ba4129e5c6ad089efea5f414e4f" => :high_sierra
    sha256 "a7e5f38c3b24a79734e12ad94dcf926cbc9cff4d7ffbff09053d86a14558d0ef" => :sierra
    sha256 "5372595ec41b8a5abb86f730b28f60cee89459bb1dfa32a4e8c6b599428c14b6" => :el_capitan
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
