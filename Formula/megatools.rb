class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.11.1.20230212.tar.gz"
  sha256 "ecfa2ee4b277c601ebae648287311030aa4ca73ea61ee730bc66bef24ef19a34"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://megatools.megous.com/builds/"
    regex(/href=.*?megatools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "943c952479691970d4c07445a765381ef52e292a012186d4bd5b8b08c645fe4f"
    sha256 cellar: :any, arm64_monterey: "ace9b475abb6e2df78ecfe570c98fec1aea7fd69e5556c551ebbf90342bea8b9"
    sha256 cellar: :any, arm64_big_sur:  "73cdf41d3408493def73830a9d2a9f1237c5d93e49f063cd3f99309c526f6a4e"
    sha256 cellar: :any, ventura:        "96a02a5b0ba2ff0fecf22246fc6177e1b7493e33dfb75dce956265a976d63a99"
    sha256 cellar: :any, monterey:       "f9e7839248bbefebb92d4a961c770086b02153af7e6003d4986f87d249274283"
    sha256 cellar: :any, big_sur:        "2190ec3f169a34c4512065127a55b34559f74d203319f1d8c1b0a2ec40525373"
    sha256               x86_64_linux:   "c85df3ea20eb762cb58d3f7be35f49d38d6c787c7c123699d925aaa64488a536"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "curl" # curl >= 7.85.0 is required
  depends_on "glib"
  depends_on "glib-networking"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "meson", "setup", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    # Downloads a publicly hosted file and verifies its contents.
    system "#{bin}/megadl",
      "https://mega.co.nz/#!3Q5CnDCb!PivMgZPyf6aFnCxJhgFLX1h9uUTy9ehoGrEcAkGZSaI",
      "--path", "testfile.txt"
    assert_equal File.read("testfile.txt"), "Hello Homebrew!\n"
  end
end
