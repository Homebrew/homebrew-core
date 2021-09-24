class HarmonyOne < Formula
  desc "CLI tool to interact with the Harmony Blockchain"
  homepage "https://docs.harmony.one/"
  url "https://github.com/harmony-one/harmony/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "d29609a99a3a2e9031d2a26414ffdc3e271c3bf9cf9331dfcb321715fef682d4"
  license "LGPL-3.0-only"

  depends_on "gmp" => :build
  depends_on "go@1.16" => :build
  depends_on "openssl@1.1"

  depends_on arch: :x86_64

  on_linux do
    depends_on "gcc" 
    depends_on "glibc" 
  end

  resource "go-sdk" do
    url "https://github.com/harmony-one/go-sdk/archive/refs/tags/v1.2.7.tar.gz"
    sha256 "85fcea1601f74f3696c4aff82dab138c1f21a4a1be0d53f771739ad3e9d24ccc"
  end

  resource "bls" do
    url "https://github.com/harmony-one/bls.git",
      revision: "2b7e49894c0f15f5c40cf74046505b7f74946e52"
  end

  resource "mcl" do
    url "https://github.com/harmony-one/mcl.git",
      revision: "99e9aa76e84415e753956c618cbc662b2f373df1"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    dir = buildpath/"src/github.com/harmony-one/harmony"
    dir.install buildpath.children

    %w[bls mcl go-sdk].each do |r|
      temp_dir = buildpath/"src/github.com/harmony-one/#{r}"

      resource(r).stage do
        mv pwd, temp_dir
      end
    end

    resource("bls").stage do
      cd buildpath/"src/github.com/harmony-one/bls" do
        system "make", "-j8", "BLS_SWAP_G=1"
      end
    end

    cd buildpath/"src/github.com/harmony-one/go-sdk" do
      system "make", "-j8"

      lib.install Dir["../bls/lib/*.dylib"]
      lib.install Dir["../mcl/lib/*.dylib"]
      bin.install "dist/hmy"
      prefix.install_metafiles
    end
  end

  def caveats
    <<~EOS
      Invoke 'hmy cookbook' for examples of the most common, important usages
      To gerenate docs in your current directories, run: 'hmy docs'
    EOS
  end

  test do
    assert_match "Manage your local keys", shell_output("hmy keys").strip
    assert_match "Harmony (C) 2020. hmy", shell_output("hmy version 2>&1").strip
  end
end
