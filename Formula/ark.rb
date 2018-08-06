class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.9.2.tar.gz"
  sha256 "301f7311143a7aec30a0a7488931cd2f1da7fc1f34c8462820c22a21ed3e2108"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab162b2b1c0ed16c8eb4ff5f4986a991fb45f0c31b18cec59112680d75644e70" => :high_sierra
    sha256 "87edd81a7bc456a5a0bef1a80d9c77d849db7ad9c8b4de30ac7f6da3cab78956" => :sierra
    sha256 "4cfd60f68c306762e87cf28387aa40fc5016d859e20a4830d27fef038a671892" => :el_capitan
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
