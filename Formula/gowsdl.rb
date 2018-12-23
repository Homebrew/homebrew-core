class Gowsdl < Formula
  desc "WSDL2Go code generation as well as its SOAP proxy"
  homepage "https://github.com/hooklift/gowsdl"
  url "https://github.com/hooklift/gowsdl.git",
      :tag      => "v0.3.1",
      :revision => "2375731131398bde30666dc45b48cd92f937de98"
  head "https://github.com/hooklift/gowsdl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ac105a303ffb54fb2fe09be85a6b913aca155cbd8c3a3fb07a525dcc662af64" => :mojave
    sha256 "e9c472ac11711508d3d4d7dc403d2697b178b9eb82b4283f5801e49a07b34353" => :high_sierra
    sha256 "83fa8252186b7c1c2d6ed205ea90a7e479c5e7df2891d77ddc3229dbaa98b49b" => :sierra
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
