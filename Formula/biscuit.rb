require "language/go"

class Biscuit < Formula
  desc     "Biscuit is a multi-region HA key-value store for your AWS infrastructure secrets"
  homepage "https://github.com/dcoker/biscuit"
  url      "https://github.com/dcoker/biscuit.git", :tag => "v0.1.3"
  version  "0.1.3"
  sha256   "0461ddb50f74b46d125939b2216be1bb283188f7c5393b940204de89f72f3e2f"

  head "https://github.com/dcoker/biscuit.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/dcoker/biscuit").install contents

    ENV.prepend_create_path "PATH", buildpath/"bin"

    cd "src/github.com/dcoker/biscuit" do
      system "go", "get", "-v", "./..."
      system "go", "build", "-v"
      bin.install "biscuit"
      prefix.install_metafiles
    end
  end
end
