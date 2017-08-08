class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro/releases/download/v1.3.1/micro-1.3.1-src.tar.gz"
  sha256 "fdede583ea2f67588c42be30a820699acc376d59f0652ca0b50c9120511f2caf"
  head "https://github.com/zyedidia/micro.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "fe79b374ccad5456e935b3a1d25cd57219fd9cc1da5214e1069290b944295321" => :sierra
    sha256 "578c23f1289f0900910004d101e14282d72569d9be5187c9cd5ae04b167e6f10" => :el_capitan
    sha256 "3360298e55ab032a51e085fa4629867a0b008eb84f9369978f483e916802fe14" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/zyedidia/micro").install buildpath.children

    cd "src/github.com/zyedidia/micro" do
      system "make", "build-quick"
      bin.install "micro"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
