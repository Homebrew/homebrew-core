class Compose2kube < Formula
  desc "Convert docker-compose service files to Kubernetes objects"
  homepage "https://github.com/kelseyhightower/compose2kube"
  url "https://github.com/kelseyhightower/compose2kube/archive/0.0.2.tar.gz"
  sha256 "d09b86994949f883c5aa4d041a12f6c5a8989f3755a2fb49a2abac2ad5380c30"
  revision 1
  head "https://github.com/kelseyhightower/compose2kube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebc7d22f93d1b4032f3d4975b23734e0e2bc1539c91e3f2100778c406f5cdddf" => :mojave
    sha256 "f657b3850b4f6fa2f941ed7de472ca0908f9ac3aefe3ab8502aac14753369135" => :high_sierra
    sha256 "1d2cb6b785c7cc7b06a5bcaf0a39fda3ad66548b2ff09fbd23bdf293f1c1ebf0" => :sierra
    sha256 "90b2466bb93be95570354475aa1cadf5b35af8944f84abfa612cea4d210d6b67" => :el_capitan
    sha256 "210e6242a05505b20208e03d278c272c1d90e54b747908119400ed018636d2a6" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kelseyhightower/compose2kube").install buildpath.children
    cd "src/github.com/kelseyhightower/compose2kube" do
      system "go", "build", "-o", bin/"compose2kube"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/compose2kube -h 2>&1", 2)
  end
end
