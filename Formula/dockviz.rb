class Dockviz < Formula
  desc "Visualizing docker data"
  homepage "https://github.com/justone/dockviz"
  url "https://github.com/justone/dockviz.git",
      tag:      "v0.6.3",
      revision: "15f77275c4f7e459eb7d9f824b5908c165cd0ba4"
  license "Apache-2.0"
  head "https://github.com/justone/dockviz.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "54b23a0f096b55794c5612e84615c0265ca6433070946ed6fc06008fe5c6a0d1"
    sha256 cellar: :any_skip_relocation, catalina:     "9307a33a515b07dc168b6494589938442a4d8e5ce9f57d96dfd2678a71fb46dd"
    sha256 cellar: :any_skip_relocation, mojave:       "a9c6471cc7405fe1a2f0dcb8eab9b171b52aeb67e4a64ce07e0b4d9f7c8aaad7"
    sha256 cellar: :any_skip_relocation, high_sierra:  "7334e941bcf3841a724103ecc7bd1cf028dc5e41bd9e80283c6f34637515cd02"
    sha256 cellar: :any_skip_relocation, sierra:       "8fbcc273dbbf14a33f44cb9d56d350440168c7943d6c29ba489c2db7cc8f293b"
    sha256 cellar: :any_skip_relocation, el_capitan:   "0df5881e825be40043790f3759fa2f3976d75c3c8273e69c4bfbd4cc039744b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "72817afdb081d5d9328e548b8f5211072c2fa87da5c89b5df47dafe713f07e23"
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/justone/dockviz").install buildpath.children
    cd "src/github.com/justone/dockviz" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"dockviz"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockviz --version")
  end
end
