class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/nuveo/prest"
  url "https://github.com/nuveo/prest/archive/v0.1.7.tar.gz"
  sha256 "48ed93539238be8589e7b95937e7d4157acea8209d0badb8a04fec7675088102"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd33b36d8adf651ac3d43e911e75e7d21d9ba86ed4a0d70367f0fe43ab137465" => :sierra
    sha256 "eebadfde61f1efc6598c26e9d99ab5f3cf32bfbbc7591d4795deda096c81d883" => :el_capitan
    sha256 "f3abe8d127bcb1fb4c8985bed8a4f277b14ac3d578e125017c762a2900d69049" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/nuveo").mkpath
    ln_s buildpath, buildpath/"src/github.com/nuveo/prest"
    system "go", "build", "-o", bin/"prest"
  end

  test do
    system "#{bin}/prest", "version"
  end
end
