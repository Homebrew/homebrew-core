class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.9.0.tar.gz"
  sha256 "3317608b8fe9bfd85b91322fc526629e734a5b1749616d77fdeac5163c297d47"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ba9a78189dfdebfdb7024be344beac7f7ba782c923dc31d30bafb70e3a42a2e" => :high_sierra
    sha256 "9b30d9134366bad33ec71e0561e76a4fbcbd31c8520b7031467fb8197494aec0" => :sierra
    sha256 "078d1b09323da566c6806fda0bed97378d72fe0270c4f346a3b7ab5bd3e13336" => :el_capitan
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
