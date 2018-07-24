class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.9.1.tar.gz"
  sha256 "489a81af6cba95973e6f5b860c82308fa9aa18c36b3b6078db38732b85134319"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b66bb97f83875a38041bc3aa9da90927f53547012a9b4d1b1e7467fb96367bb" => :high_sierra
    sha256 "8b3879a7e40332f3c06aca8acce09838879d8080c5e3338a197d5c65bdd1c176" => :sierra
    sha256 "96a5462fae7e5578dbc0496c473a6b59763e821f0431a8eb89a365cf4c3fc430" => :el_capitan
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
