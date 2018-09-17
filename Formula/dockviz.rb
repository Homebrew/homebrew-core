class Dockviz < Formula
  desc "Visualizing docker data"
  homepage "https://github.com/justone/dockviz"
  url "https://github.com/justone/dockviz.git",
      :tag => "v0.6.3",
      :revision => "15f77275c4f7e459eb7d9f824b5908c165cd0ba4"
  head "https://github.com/justone/dockviz.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9c6471cc7405fe1a2f0dcb8eab9b171b52aeb67e4a64ce07e0b4d9f7c8aaad7" => :mojave
    sha256 "7334e941bcf3841a724103ecc7bd1cf028dc5e41bd9e80283c6f34637515cd02" => :high_sierra
    sha256 "8fbcc273dbbf14a33f44cb9d56d350440168c7943d6c29ba489c2db7cc8f293b" => :sierra
    sha256 "0df5881e825be40043790f3759fa2f3976d75c3c8273e69c4bfbd4cc039744b3" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
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
