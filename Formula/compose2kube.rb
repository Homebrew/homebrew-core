class Compose2kube < Formula
  desc "Convert docker-compose service files to Kubernetes objects."
  homepage "https://github.com/kelseyhightower/compose2kube"
  url "https://github.com/kelseyhightower/compose2kube/archive/0.0.2.tar.gz"
  sha256 "d09b86994949f883c5aa4d041a12f6c5a8989f3755a2fb49a2abac2ad5380c30"
  head "https://github.com/kelseyhightower/compose2kube.git"

  bottle do
    sha256 "e77b7695ecee39b715f8e04a11a4b0d1299e6c3f02350414c27cf68cd25eb7cb" => :sierra
    sha256 "c2b21ee0e5d1afbb2bf411cab7c8080f391967a67ccd0ebb798bcd3aa9158588" => :el_capitan
    sha256 "95150f85aed2956b82385d0d73cf45cd9bc2445100f69eaae19c0388f00b37ec" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kelseyhightower/compose2kube").install buildpath.children
    cd "src/github.com/kelseyhightower/compose2kube" do
      system "go", "get"
      system "go", "build", "-o", bin/"compose2kube"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/compose2kube -h 2>&1", 2)
  end
end
