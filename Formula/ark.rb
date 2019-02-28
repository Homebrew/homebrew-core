class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.10.1.tar.gz"
  sha256 "7e618a2581a4a9bae19cbe5a8cb71adb768bd2416203c0ba909a6b3a2e19aa0f"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c15b83535cb655e396204e9f1887dace4b3cb88558079627579628137a675ca" => :mojave
    sha256 "0132082ee86a01b820b368e6016559e59c24722faf40d70a585394994637f3b2" => :high_sierra
    sha256 "33c5450785b103c91e5c2b509c9e16364dce36a07b4ed246c4454b71140f8fc4" => :sierra
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
