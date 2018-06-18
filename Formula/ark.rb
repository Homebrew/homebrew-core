class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.8.2.tar.gz"
  sha256 "149b5262e9e113a8963cd97e1b32c6cfc1eea23b2cc45ffdda9b81a789da3e26"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8669d5fbfa3642ed3ef3a729675ccf3e655464885291fa12e1f56c468d6c44c" => :high_sierra
    sha256 "99c0024c44d20bc741305003b7945f3819420e7b73e26309bef4c90fa5a03cff" => :sierra
    sha256 "454061ac749a8fd133c6fe12d069a12f9a692668c339023a94b6519a23b9041d" => :el_capitan
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
