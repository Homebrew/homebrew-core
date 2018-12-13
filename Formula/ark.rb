class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.10.0.tar.gz"
  sha256 "95d7cd269f085a26f957b905c2232d9dffb81acf0af0bbdc0300f9e8de535e38"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a72fe0416004c33e53bec256e8021ffab13a941f251526faf175fac15e3010d" => :mojave
    sha256 "eb0f136f09565542a999126f6f8c74c25093b79cb982588a59141540c5d215e4" => :high_sierra
    sha256 "4234249db66744eb35e0b59df7f9f0bfff572d331dc3c5ff5b7ef6f4e6329346" => :sierra
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
