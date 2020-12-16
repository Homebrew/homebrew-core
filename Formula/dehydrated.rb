class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.io"
  url "https://github.com/lukas2511/dehydrated/archive/v0.7.0.tar.gz"
  sha256 "1c5f12c2e57e64b1762803f82f0f7e767a72e65a6ce68e4d1ec197e61b9dc4f9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b9332dca6c3e4d9b480836fa0655fa6982f516e55578ce73d7628560da90ade" => :big_sur
    sha256 "9dd59ec022c69ea48b0ffc7bc04ee3104cc7138a69d62f4cd0f39e8f8e511cc1" => :catalina
    sha256 "aee673b9f0911f72f685cc2cd55018b0d0d1db9a87e9896c4c488f434eda6449" => :mojave
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
