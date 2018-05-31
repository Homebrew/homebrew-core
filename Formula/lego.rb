class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://github.com/xenolf/lego"
  url "https://github.com/xenolf/lego/archive/v1.0.0.tar.gz"
  sha256 "3e521dc04afa25a531acd0c45dfb897d7081383867895599022d57b8c4f1a078"

  bottle do
    cellar :any_skip_relocation
    sha256 "30e96ef82a7e42060138a83f43c4b214ece39d125ddcf58c6375910b8f8aecae" => :high_sierra
    sha256 "0b100f105767cd4176ce7dd7b1c885de0e0e5eda20dc4c20ddeb41b56f8ee0f8" => :sierra
    sha256 "ee14208549185fc5f62085d095468d5f2ad03c83e78d1b9dfb8a05f21fb110b2" => :el_capitan
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
