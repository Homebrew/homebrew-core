class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/v1.3.0.tar.gz"
  sha256 "4d993dd790345e54dd963467a475ae160a7133bae7ee42844f15d5e82c1fb36e"
  revision 1
  head "https://github.com/aptly-dev/aptly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d648543b78ab122fd96276a9e70f3edf90bbabb4b6190ab9a742262ee9e4460" => :mojave
    sha256 "8ee9d2d3b4c072cad39487f6dfcf37189c4258eed4496845d20d8621806ae0db" => :high_sierra
    sha256 "6425b01749d2cd2c6e9e748e59b71f26a47945d43a300858a305179dc370d61c" => :sierra
    sha256 "64ad68557e92d24163204792cee94b606c30f3ca584979a1f4158cdec102bb9a" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/aptly-dev/aptly").install buildpath.children
    cd "src/github.com/aptly-dev/aptly" do
      system "make", "VERSION=#{version}", "install"
      prefix.install_metafiles
      bash_completion.install "completion.d/aptly"
      zsh_completion.install "completion.d/_aptly"
    end
  end

  test do
    assert_match "aptly version:", shell_output("#{bin}/aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
