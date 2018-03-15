class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/smira/aptly/archive/v1.2.0.tar.gz"
  sha256 "e41ee52ba530b65ff5ec8b1ef3ee9c61882d1c44857d343b9a760e8a8e4230d7"
  head "https://github.com/smira/aptly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc6eac38589d708fc99ec4dbe6d4b0f22765ed893f7f2ab19ccee50306d870f0" => :high_sierra
    sha256 "fdc4509d1f83c16c4d4b1eec87e6cfe5bc517eec3a67ad515244eeb9eb994d3e" => :sierra
    sha256 "5fbb7c41aeea6dbcc1c91e3bc1cf9c156e4d8820a828b8c935e07a9b3d3df942" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/smira/aptly").install buildpath.children
    cd "src/github.com/smira/aptly" do
      system "make", "VERSION=#{version}", "install"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "aptly version:", shell_output("#{bin}/aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
