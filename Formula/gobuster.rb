class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster.git",
      :tag      => "v3.0.1",
      :revision => "9ef3642d170d71fd79093c0aa0c23b6f2a4c1c64"

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

    dir = buildpath/"src/github.com/OJ/gobuster"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"gobuster"
      prefix.install_metafiles
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

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output
  end
end
