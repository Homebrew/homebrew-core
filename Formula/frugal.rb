class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.4.2.tar.gz"
  sha256 "fd650a6972a6f0506574efa26c202af870391ddd1b5a9daf4319ffe83f79f555"

  bottle do
    cellar :any_skip_relocation
    sha256 "310a8eb5b072941439e5d04845bdadbfe2ad85149b3a6b2482359ebfb61efdce" => :mojave
    sha256 "e90a43faac32b332de978e0dc9911c81eb9cc6c502c5c942f5e760e25535e43b" => :high_sierra
    sha256 "c3a9789c0dc9d4a8c911d12c14625767f0fa445b2a82817ac3dbdfbdea999563" => :sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd "src/github.com/Workiva/frugal" do
      system "glide", "install"
      system "go", "build", "-o", bin/"frugal"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
