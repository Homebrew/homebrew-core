class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.9.6.tar.gz"
  sha256 "1af184c3bd5b8b4227dcc65123dbda600e838c8812423407ff9989d2b76a22d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "e603b55c20b462324577c9369da0cfb5f9777467016cdf911043942de9dd8d6f" => :mojave
    sha256 "f38c4dc1af3ea10d44799e3674d5b5bc0eb2d95b4e456530d7f0235ecd344c84" => :high_sierra
    sha256 "6d2c3b34c2091c085fcd12f7c60aab48d63afeda90c6d55968f3769ccf1d724f" => :sierra
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
