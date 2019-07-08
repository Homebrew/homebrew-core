class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.12.2.tar.gz"
  sha256 "982d090add119b336bb70edb1c394c9ea835135708fa66d754d5159dcbe8c467"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cb38dd46fc38adda97cee26f0ae38d0defa2aa3eedaf3a4517d3ca304cd9448" => :mojave
    sha256 "33a8801ddcfb493a72775f62e1500e376afe0eec6087499be80c85001cbebe9a" => :high_sierra
    sha256 "659559bd0e30b2164ac4440a77a87861bdd8a5f6de9d938a3b43e9a0910fc7af" => :sierra
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
