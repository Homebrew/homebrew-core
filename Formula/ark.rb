class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.10.0.tar.gz"
  sha256 "95d7cd269f085a26f957b905c2232d9dffb81acf0af0bbdc0300f9e8de535e38"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa3c5cafda841bd1521737db6044eb14244a7d69979834c689b853e88684ae9f" => :mojave
    sha256 "e8935626d6af3fbe4bd44a84ab128a65caa63699be4cacabbfadb48cd25c57fc" => :high_sierra
    sha256 "24cd661bb525cf31a4ae329843cef79ed6544e102f452f163388aa4242233a34" => :sierra
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
