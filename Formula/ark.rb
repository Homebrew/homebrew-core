class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.9.10.tar.gz"
  sha256 "be21092955de1382942a6575fa3f5e7fcbae945a0e4beb07af8ac528049c1838"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5397071cfb76145c99f79f64bc6be312bc75bb3e1502a2b9a1df342c222ca76" => :mojave
    sha256 "22a6d85e8815d0b1b2761a00cd37bc107aca7642a5185a5d9e07faabef79b114" => :high_sierra
    sha256 "b0e139e96fbffb46b12cad5f84156cc75e05b060388f69a8ea9365e6070411df" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/heptio/ark").install buildpath.children

    cd "src/github.com/heptio/ark" do
      system "go", "build", "-o", bin/"ark", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/heptio/ark/pkg/buildinfo.Version=#{version}",
                   "./cmd/ark"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/ark 2>&1")
    assert_match "Heptio Ark is a tool for managing disaster recovery", output
    assert_match "Version: #{version}", shell_output("#{bin}/ark version 2>&1")
    system bin/"ark", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/ark client config get 2>&1")
  end
end
