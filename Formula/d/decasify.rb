class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https://github.com/alerque/decasify"
  url "https://github.com/alerque/decasify/releases/download/v0.8.0/decasify-0.8.0.tar.zst"
  sha256 "1d35006ffc8bdc7e01fe7fc471dfdf0e99d3622ab0728fc4d3bb1aea9148214e"
  license "LGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b25223707b94797890dd49e7aa98c2a477ff57a902ff2bdcf0f9ebd6c74b81c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01ea70c5a5a716e6ac0ea825871890b1f9d1e27b1d697367631497212908052f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de126245eb0ae0d0bcffedd4b1d7fa5fa1b6ff83acb269d0b541c584dedc84de"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf208333b9f376d845f8c271d5a26d4b707682ecb2a41f7fa9cf2f3203984ce4"
    sha256 cellar: :any_skip_relocation, ventura:       "53508523d514a1e13970caedf30d11eb9284a9fb2a89b1d4b045144b040963c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d8d47baa6a56859dd30c5c97f26c146082ef76ee8b2c30a68f99f3968c0bbec"
  end

  head do
    url "https://github.com/alerque/decasify.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jq" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "decasify v#{version}", shell_output("#{bin}/decasify --version")
    assert_match "Ben ve İvan", shell_output("#{bin}/decasify -l tr -c title 'ben VE ivan'")
  end
end
