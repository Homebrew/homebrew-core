class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/smira/aptly/archive/v1.1.1.tar.gz"
  sha256 "92aa5caa12d756cb7469fa5772a03d7631b73d655b7329408a4d597ee8fb0ba4"
  head "https://github.com/smira/aptly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7543281b179d573f60b4d76da4bb93f4e2ac2fed7e3fa46cc5eb5cad12138614" => :sierra
    sha256 "5d3cc4f96412d1203fee2f6b893800bc8380c3b668f1c8235a3785d005860ae9" => :el_capitan
    sha256 "88cfa1071de3be08d0793e91177738280e1bf4812b0a74f784122b79b078f215" => :yosemite
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
