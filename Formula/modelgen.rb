class Modelgen < Formula
  desc "Generate models from reading your database"
  homepage "https://github.com/LUSHDigital/modelgen"
  url "https://github.com/LUSHDigital/modelgen/archive/1.0.0.tar.gz"
  sha256 "31f15b7817054dff73df051e87ee27565cbd36dc839d3f2fde2516b2420573b5"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "-ldflags", "-X main.version=#{version}"
    bin.install "modelgen"
  end

  test do
    system "#{bin}/modelgen", "version"
  end
end
