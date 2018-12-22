class Gowsdl < Formula
  desc "WSDL2Go code generation as well as its SOAP proxy"
  homepage "https://github.com/hooklift/gowsdl"
  url "https://github.com/hooklift/gowsdl.git",
      :tag      => "v0.3.1",
      :revision => "2375731131398bde30666dc45b48cd92f937de98"
  head "https://github.com/hooklift/gowsdl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "60124759822dfa9cbb182818488f70f7dff36d68b1936b9a457844812f2034bf" => :mojave
    sha256 "631f836ce7d3f08f8becbd915ef2634b456e256c6cbb4f0450657cc6d1a13468" => :high_sierra
    sha256 "4395ff37e13fd146e3114beac5e8faa6a6a03819253760f5ef493c834374b905" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    srcpath = buildpath/"src/github.com/hooklift/gowsdl"
    srcpath.install buildpath.children
    srcpath.cd do
      system "make", "build"
      bin.install "build/gowsdl"
    end
  end

  test do
    system "#{bin}/gowsdl"
  end
end
