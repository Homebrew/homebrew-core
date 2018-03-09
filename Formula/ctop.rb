class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop/archive/v0.7.1.tar.gz"
  sha256 "baa632235c43ed84557a13b475a1972a8327a55babb6dd08d2d72643f8442ed2"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe0731802788f0950dcba7a4fd2048c6e86a1cf14da29723e42f15eac851214e" => :high_sierra
    sha256 "eb2733da770a3284f3f2db7ee8a66a1675e849426d9c6c5a06866ca162b94022" => :sierra
    sha256 "4ab7beee92e171ed5b723c42e406edb08c0e2c6e292136564b85aaabc11dc458" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bcicen/ctop").install buildpath.children
    cd "src/github.com/bcicen/ctop" do
      system "make", "build"
      bin.install "ctop"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
