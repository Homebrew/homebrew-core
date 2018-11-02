class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://github.com/xenolf/lego"
  url "https://github.com/xenolf/lego/archive/v1.1.0.tar.gz"
  sha256 "65af2e455bfabfdede3ebe66162280120462d100d5e647be41b1a30ddffc4044"

  bottle do
    cellar :any_skip_relocation
    sha256 "daac836746b6cfc7ba2aaa748e438b42cf725e2e946f5d59b9998f99f231662b" => :mojave
    sha256 "f479f3752c94a3ec6592698925686fb8ed215d13b7210b66ae7b6c50565385dd" => :high_sierra
    sha256 "29dad74958b2799553a699fe544d48c414ed02e1ebf2b67bd912740f22d59623" => :sierra
    sha256 "06452881b46e6f9711313a5ff84429d437d83b3f1234cae370cacc9a3e4d66c7" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xenolf/lego").install buildpath.children
    cd "src/github.com/xenolf/lego" do
      system "go", "build", "-o", bin/"lego", "-ldflags",
             "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
