class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.9.3.tar.gz"
  sha256 "a5a1299a1eb966b1211df8a537ce7806e0a32ac33e6030b10393a700cb29ebd9"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef40fb816bf82fca4fa06efe2c7843499a7facd62687f327ed85440e1c350660" => :high_sierra
    sha256 "cb398dbac48c3329ac5a6794d560fa456d2a7d81726852883f41db5173e4fb1f" => :sierra
    sha256 "3ebbfe8c0580b2405ded45862e4aa2b2e699410efa23f5c1de8d868ebbe7f0c1" => :el_capitan
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
