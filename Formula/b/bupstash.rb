class Bupstash < Formula
  desc "Easy and efficient encrypted backups"
  homepage "https://bupstash.io"
  url "https://github.com/andrewchambers/bupstash/releases/download/v0.12.0/bupstash-v0.12.0-src+deps.tar.gz"
  sha256 "e3054c03b0d57ba718bd2cab8c24df13153369dea311e5a595d586ad24865793"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "11880e340498d539dc45fc413508f1bda1985c1f1d1e9b9ae818287ffe028141"
    sha256 cellar: :any,                 arm64_sequoia:  "a1955968ad1ced6369767619595453bcd9260fa963878cec01f51ed10ae0f4f9"
    sha256 cellar: :any,                 arm64_sonoma:   "282702198d0383461a3827c2727a2cef576f7e68cf32f88af49fd1591602e0ed"
    sha256 cellar: :any,                 arm64_ventura:  "5c75007fe3422c999e4843325a6d7939850e60266485ae78b514b4f56f19114f"
    sha256 cellar: :any,                 arm64_monterey: "31c1594f63290770e6b4e5e624c24a471fc905a4484da6d0c6675371e093b22c"
    sha256 cellar: :any,                 sonoma:         "5e4323b39fdc2751adfb15eeb1fb6224f7f5631fbb44995dfaaf9b8bd5bca6e3"
    sha256 cellar: :any,                 ventura:        "553dcd5d10275673f1106914e7af449ac1ebe52ec80f99150206370426a7d558"
    sha256 cellar: :any,                 monterey:       "a78d691c6274743184a5ec48d717f1835d016c615bdb1e6bb3e1e9a5d6b3c3f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6f00098d6b1cd79ddf82999ef4371f46ecd2935ccf0c6c23be33f2d4aab36933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b61eb9cbb571a97f1064e6b0e0766e2fc19e1b7691ab8cc988ea4db67f8d5182"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libsodium"

  resource "man" do
    url "https://github.com/andrewchambers/bupstash/releases/download/v0.12.0/bupstash-v0.12.0-man.tar.gz"
    sha256 "bffe4a9e7c79f03af0255638acfa13fb9f74ed5d6f8987954db1d3164f431629"
  end

  def install
    system "cargo", "install", *std_cargo_args

    resource("man").stage do
      man1.install Dir["*.1"]
      man7.install Dir["*.7"]
    end
  end

  test do
    (testpath/"testfile").write("This is a test")

    system bin/"bupstash", "init", "-r", testpath/"foo"
    system bin/"bupstash", "new-key", "-o", testpath/"key"
    system bin/"bupstash", "put", "-k", testpath/"key", "-r", testpath/"foo", testpath/"testfile"

    assert_equal (testpath/"testfile").read,
      shell_output("#{bin}/bupstash get -k #{testpath}/key -r #{testpath}/foo id=*")
  end
end
