class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.14.0.tar.gz"
  sha256 "55b260c9a6cb88494cbe1543c49108d824248fda887dfdf4bb5d7a97d18aaf8e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1586b03a67104e7d0b7ac1eae0c7d670fb905d257951b95ead03e4192ebc22f" => :high_sierra
    sha256 "6178c5b1531d14fe0cf91f8483f2c87e5cdfb1c83786e80883a9f4fb9fc8d474" => :sierra
    sha256 "227ade26ff2c6ed99b9c5fafcf37acbfc17a6440e5f5eed3f91599faa96c0fc4" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd buildpath/"src/github.com/Workiva/frugal" do
      system "godep", "restore"
      system "go", "build", "-o", bin/"frugal"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
