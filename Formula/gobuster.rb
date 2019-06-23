class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/v3.0.1.tar.gz"
  sha256 "9c70c73b4c08b02d1fc722cd82eda3d8ce683de53b08c8bddd31fc5c4d90a977"
  head "https://github.com/OJ/gobuster.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8333bbd8af7dd797ac537138a3cc5f43e84dca5f8f405c73e78ac4c8dc051b19" => :mojave
    sha256 "396aae866477abbcd373a0419e6e6a554403bc9f6500df0b564c704947324021" => :high_sierra
    sha256 "56ab5f1e20a60feae0da0c76bbc3902363189889b94013f95348fa1d2d05ca5a" => :sierra
    sha256 "df059226d63e3a19c8d0e9c2355e67872ec3db5a8df25683b1706771b8cc6558" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    src = buildpath/"src/github.com/OJ"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"gobuster"
    end
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dns -d https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output
  end
end
