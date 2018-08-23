class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/goreplay.git",
      :tag => "v0.16.1",
      :revision => "652e589e2b71d5dfa4d2a70431d21b108a5e471e"
  head "https://github.com/buger/goreplay.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7c9758b1a058ae433baefbc0e9d02cb84e2e5e6df16a9f5b376cac0a3e9df93" => :mojave
    sha256 "204f649341531e36b220221f6dd76b3b637ea4880720111cddda6bb5224be5ed" => :high_sierra
    sha256 "78689bec0668532515a42e5274733ad296998e0e623bdbd3bbd66d2d0fb8f1e7" => :sierra
    sha256 "dd3721a8686fb9e08074a6787d2bbefc5d3f3a585b99e52f40734a4516564754" => :el_capitan
    sha256 "5263cd24fee9bae85eb69aafe887865642e039236e810339f84aa546e6d444d7" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/buger/goreplay").install buildpath.children
    cd "src/github.com/buger/goreplay" do
      system "go", "build", "-o", bin/"gor", "-ldflags", "-X main.VERSION=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gor", 1)
  end
end
