class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.13.0.tar.gz"
  sha256 "53933c6436187f573128903701ce74ac341793e892d3c2f57c822c0ce3c49e11"

  bottle do
    cellar :any_skip_relocation
    sha256 "2930c3d3530bbe764251ca49f95e046bf879f547f53204dd2897030d04eb95a5" => :mojave
    sha256 "6fa326ecfc938188215160eb8808a927430c91171279248a42b45f6926f35826" => :high_sierra
    sha256 "bc391b72bfb16a2669fd79126b8844a4a7293bf04eab44bb562acb76335d54d9" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/tcnksm/ghr"
    dir.install Dir["*"]
    cd dir do
      # Avoid running `go get`
      inreplace "Makefile", "go get ${u} -d", ""

      system "make", "build"
      bin.install "bin/ghr" => "ghr"
      prefix.install_metafiles
    end
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_include "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
