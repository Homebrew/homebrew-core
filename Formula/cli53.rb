class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.15.tar.gz"
  sha256 "6b9fcce93071782f9cdfe1a05f098aa08e83f317a0685c2a7f09bafb7d74d24f"

  bottle do
    cellar :any_skip_relocation
    sha256 "82e7f1b17ab07fc2ce7b70ee460d762c3044ea9321de7f1290a33d931e0d629f" => :mojave
    sha256 "aa503927d31112aef3c44118762a9b3bb30a3ee5329947427903c25eae6baea7" => :high_sierra
    sha256 "045133ce67ca54c26ee6b64045c9e7c954f169ce683293350305773e20f2db23" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/barnybug"
    ln_s buildpath, buildpath/"src/github.com/barnybug/cli53"

    system "make", "build"
    bin.install "cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
