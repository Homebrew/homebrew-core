class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://github.com/xenolf/lego"
  url "https://github.com/xenolf/lego/archive/v1.0.0.tar.gz"
  sha256 "3e521dc04afa25a531acd0c45dfb897d7081383867895599022d57b8c4f1a078"

  bottle do
    cellar :any_skip_relocation
    sha256 "f583ca0ee03b5dd25d5a54bc9cb455087a0a04f19523108e4196cfd89f7aec35" => :high_sierra
    sha256 "b19847287bd1abb9003307e7a6ba42fb0ef13336bd569dee1d9dc19df340cbf6" => :sierra
    sha256 "2dbe1268ad4ffa8eb74be6d664d31075f8fe58fa1bffc07534502822fb4a23f9" => :el_capitan
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
