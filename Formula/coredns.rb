class Coredns < Formula
  desc "Plugin-driven DNS and service discovery"
  homepage "https://coredns.io"
  url "https://github.com/coredns/coredns.git",
    :tag => "v1.3.1",
    :revision => "6b56a9c92130d50cee9bd92aaee500dbccff395f"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    build_dir = buildpath/"src/github.com/coredns/coredns"
    build_dir.install buildpath.children

    cd build_dir do
      system "make", "godeps", "all"
      bin.install "coredns"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/coredns -version")
    assert_match /CoreDNS-1.3.1/, output
  end
end
