class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.de"
  url "https://github.com/lukas2511/dehydrated/archive/v0.6.1.tar.gz"
  sha256 "441d89af4592e3eb5744eb177124b4d16ca78b416f634371e839db384012844a"

  bottle do
    cellar :any_skip_relocation
    sha256 "73aedd02d64fb10b49ffe0212c5b5b787f9d21821b99f5583aa47b3eb35188f4" => :high_sierra
    sha256 "73aedd02d64fb10b49ffe0212c5b5b787f9d21821b99f5583aa47b3eb35188f4" => :sierra
    sha256 "73aedd02d64fb10b49ffe0212c5b5b787f9d21821b99f5583aa47b3eb35188f4" => :el_capitan
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/lukas2511/dehydrated").install buildpath.children
    cd "src/github.com/lukas2511/dehydrated" do
      bin.install "dehydrated"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"dehydrated", "--help"
  end
end
