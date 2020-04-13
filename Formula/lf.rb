class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r14.tar.gz"
  sha256 "5266afa808f4612733af65289024c9eb182864f6a224fdfdf58f405a30c79644"

  bottle do
    cellar :any_skip_relocation
    sha256 "86added59852eebeeea8152ed69feb042f6f4ccc1ca998e3df6ca1629f746fe7" => :catalina
    sha256 "ad4cfc498d617d41c02b9482c0411b8048d7eaa934cfed114861555de742cf7c" => :mojave
    sha256 "e25cfc6246e04b13e90260433cf1fc27a28af17b82ac7d6bb93e09123faa4f61" => :high_sierra
    sha256 "49a61cf93df5beac903c441087755cc81a4062bcd6f4665aa678cbf21e5c286b" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["version"] = version
    (buildpath/"src/github.com/gokcehan/lf").install buildpath.children
    cd "src/github.com/gokcehan/lf" do
      system "./gen/build.sh", "-o", bin/"lf"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
