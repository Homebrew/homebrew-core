class Hyper < Formula
  desc "Client for HyperHQ's cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
      :tag      => "v1.10.16",
      :revision => "860cca29de31268664bf04bd7a87c3ca2c1d675e"
  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9dda15ac5bc72c947a8d4604c7f2e7274b81bda9227522b08b66f44cadd527c2" => :mojave
    sha256 "7421ad982d00cd24c1397431aafcc5714db16236a50d8971eb59fdbb919a04ff" => :high_sierra
    sha256 "3d42b5e882de272e6830ee779ea7c3d0c430492a685309764f9a11520f5a7761" => :sierra
    sha256 "749d420319b8514008f33eaa78ec3bebb760bcae24d1541a676b9777272444d6" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/hyperhq"
    ln_s buildpath, "src/github.com/hyperhq/hypercli"
    system "./build.sh"
    bin.install "hyper/hyper"
  end

  test do
    system "#{bin}/hyper", "--help"
  end
end
