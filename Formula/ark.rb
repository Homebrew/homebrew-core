class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.9.5.tar.gz"
  sha256 "1c4efca6e3e4d26579d21c41ee085efbbad7eac3dcbfde48a648403b81338161"

  bottle do
    cellar :any_skip_relocation
    sha256 "e50cb6c48e065c22a5a042f0260b89475a9e509bff44449d5f71573aadebe479" => :mojave
    sha256 "46829baea5dd3b52e51cf707aaa595e4c047c752899a9d822bb0743728a30885" => :high_sierra
    sha256 "da7ecdcde9e3bb843a82e85ed8f5d52b6604c3469b307c9da5ad8e8f3fe4f25d" => :sierra
    sha256 "1a519d097185828305f9ecfaac924d53efd4ad90e9d572931fa807f7ab74cdaf" => :el_capitan
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
