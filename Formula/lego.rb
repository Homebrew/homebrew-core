class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v2.5.0.tar.gz"
  sha256 "f2665affc8e55ed95fcd6b24b826c7d3a343c24df8d91838d4beb87b770bcf3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "362557973f8a51e3cf586f3ea19753a6237a9d355567a206c369f9505db71e1f" => :mojave
    sha256 "42dd0fd5ee7a8ea1f370e55fdb77d0367d72ed32741a4a716851a6c90f6ec676" => :high_sierra
    sha256 "1a49544645a6a4dea652d56ece48e9ff7c8d152722985503638601322da80518" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/go-acme/lego").install buildpath.children
    cd "src/github.com/go-acme/lego/cmd/lego" do
      system "go", "build", "-o", bin/"lego", "-ldflags",
             "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
