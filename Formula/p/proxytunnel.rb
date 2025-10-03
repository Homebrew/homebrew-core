class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "106cfba7aba91faccb158e1c12a4a7c4c65adc95aa1f81b76b987882a68c5afb"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6003b5468d9eb16d028cfac02ad7700bb173650fbcb7b4c1be87cf3267a636f"
    sha256 cellar: :any,                 arm64_sequoia: "6b7dd6ac425100875ce71c7439bfba022d89b03470e108f040abf8f9a1865ed1"
    sha256 cellar: :any,                 arm64_sonoma:  "4180c52f43d7bc1d79471a57ec13978ace1642e6a9ebf003b5867ad12c22b08f"
    sha256 cellar: :any,                 arm64_ventura: "b304a1e197fc8840549b2b4f240a6eec34dbdd45eb035bed45fb591201dd0ed3"
    sha256 cellar: :any,                 sonoma:        "20b05437c58f9ac5e129dbfd9da88d6c57338deb994ad88af6ee2a558a430304"
    sha256 cellar: :any,                 ventura:       "a7877a40edfc840c91921d0bfb161e1f87d4eef6b8f3bc06789d9a6b89b06dbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1054f31d72acfeb8d3e4b925620f5d8140349158552c6288db753af40097b72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f0a86ab22a1406b3215b1f48abd7bb1cd686a2eab4cd707f989a9bee830a4c"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"proxytunnel", "--version"
  end
end
