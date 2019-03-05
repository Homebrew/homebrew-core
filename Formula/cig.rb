class Cig < Formula
  desc "CLI app for checking the state of your git repositories"
  homepage "https://github.com/stevenjack/cig"
  url "https://github.com/stevenjack/cig/archive/v0.1.5.tar.gz"
  sha256 "545a4a8894e73c4152e0dcf5515239709537e0192629dc56257fe7cfc995da24"
  head "https://github.com/stevenjack/cig.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a7298ca161ad636a1efb286bf336975d3d17c90625d40433c1207983562c5e3e" => :mojave
    sha256 "a48e341826857fe9753dc444fa86d5ce121f4acc28a67e79c4955156c9707ccd" => :high_sierra
    sha256 "8d6219bd7d8f795608a58bf95fed5489cf8aa8266b3d06e6ff506037fa449ead" => :sierra
    sha256 "c64c5aaab66ee0853e0b3437c002dcf233fd543a019e4b411f9cf3f9555de702" => :el_capitan
    sha256 "d349ccf020a30a7db72333a4aa1a8f73bcb2b3c6f0984c7a0e88de38bc07ed4c" => :yosemite
    sha256 "b61176af3e53d2505f36ee3deafbb92a5f02f6c0841fefdcdfdd084821a95837" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/stevenjack").mkpath
    ln_s buildpath, "src/github.com/stevenjack/cig"
    system "godep", "restore"
    system "go", "build", "-o", bin/"cig"
  end

  test do
    repo_path = "#{testpath}/test"
    system "git", "init", "--bare", repo_path
    (testpath/".cig.yaml").write <<~EOS
      test_project: #{repo_path}
    EOS
    system "#{bin}/cig", "--cp=#{testpath}"
  end
end
