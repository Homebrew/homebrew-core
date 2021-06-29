class Kiya < Formula
  desc "Manage secrets for development and infrastructure deployment using GCP"
  homepage "https://github.com/kramphub/kiya"
  url "https://github.com/kramphub/kiya/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "2f676222d82d66253dc9ef56a51f3bdb7952335305226a351e0825fb919c1b97"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    bin_path = buildpath/"src/github.com/kramphub/kiya"
    bin_path.install buildpath.children

    cd bin_path do
      system "go", "build", "-o", bin/"kiya", "./cmd/kiya"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/kiya", "--version"
  end
end
