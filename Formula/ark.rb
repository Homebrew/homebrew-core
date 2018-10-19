class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.9.8.tar.gz"
  sha256 "9e293363f4a5f53a77561f204b2055a29beae353b351e993fb62672f30cc93c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7d2a45c9e921fab414e6f2f4ba2acd74416c48a44f621fdff5de5b2735e1d51" => :mojave
    sha256 "0d55d1bf7ee704c8a1935d20981dd3f4a3fe0b7d3028f7d5f087d245f01b84df" => :high_sierra
    sha256 "647a0fe90903eaa991820b17ffee0e24940470325f88d3200fae40f0a0dcfdc0" => :sierra
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
