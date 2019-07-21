class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r13.tar.gz"
  sha256 "fe99ed9785fbdc606835139c0c52c854b32b1f1449ba83567a115b21d2e882f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb80b454e19c4a3c9022924fa03c838b4084fc8b73d8b69e5708f81bc97903ae" => :mojave
    sha256 "34230d8e1e260dac0f02984f4c63074ffb9e5d05b47bd1c29fc63c4d9b95488a" => :high_sierra
    sha256 "a3123479fc02341f27de6137452254d2fe88f9553aa64c997d3331f06600a255" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
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
