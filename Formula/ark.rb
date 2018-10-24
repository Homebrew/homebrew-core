class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.9.9.tar.gz"
  sha256 "8f86b21db9fea41dba6b34614dffa0446c9a040f1a631c24aebd445eadd42387"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c59a68cbc791509eab786e8715e79d4838db50cdff98fcb4ef69de5636d0163" => :mojave
    sha256 "5f1ade122477300ea64ea7e76397012a7476d55729912ebb9d036858d3e5b75f" => :high_sierra
    sha256 "e609964945d4cc62502e9115cb6555e3ba00172fedaea3d005dac5c88fbb65c9" => :sierra
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
