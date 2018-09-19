class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180918193500.tar.gz"
  sha256 "6b690a81bc7adee2893bb2d6abdeba5501a9f4a002ff1bdbb37c6fa6853ca339"

  bottle do
    cellar :any_skip_relocation
    sha256 "db5aceb89e1608bdd3c50f5db06dbdf11d084c91f8b4d422dd22bfbfe15d2fd9" => :mojave
    sha256 "70b7f5db07c0a61268aff4eb9d4e104ecc81862c188f640a7cf36f3900c1e331" => :high_sierra
    sha256 "c521a12e2ad74e43ddf0d181217a4fd130afd070a69b313e07c25a9c78212e70" => :sierra
    sha256 "2795fc4f3cbe0bc350dd4070004403793c72428b3d9aabab0085cd8cd259c99c" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
