class Mairix < Formula
  desc "Email index and search tool"
  homepage "http://www.rpcurnow.force9.co.uk/mairix/"
  url "https://downloads.sourceforge.net/project/mairix/mairix/0.24/mairix-0.24.tar.gz"
  sha256 "a0702e079c768b6fbe25687ebcbabe7965eb493d269a105998c7c1c2caef4a57"
  license "GPL-2.0"
  head "https://github.com/rc0/mairix.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/mairix[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "588fe8d2cc66f1f63c8ba35ed5fed8df99c839cecc867107371c8d8b9741dd8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca582c86e13846ea4d659ae4f63ebb6db21a7199d8ea713c9a764997b05925dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b47d8c878e9315d316c48f8bde023532b8704785cde690f6d1c69e2b92a26787"
    sha256 cellar: :any_skip_relocation, ventura:        "fe9fd8565bf77b7f4577330fd55cc019c5fd8e00900326143393c608aacf7264"
    sha256 cellar: :any_skip_relocation, monterey:       "86f72db4522c569ac628e9ef8b726ec4cac27bfd2c06d264070349c1ceb5e3a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "26221ca2d6ce638ad3f47a597a4b67654ecaaa335f54577b380404951733113e"
    sha256 cellar: :any_skip_relocation, catalina:       "3c74d81ccb04da6f3fa9f0f734861738f6dcc924bde12dc8055fd73ea1be68ce"
    sha256 cellar: :any_skip_relocation, mojave:         "483128f4a24cbf40c26ceef2a9951c44992c57f114327671883b8ab7b9da8569"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5975d9e5b741611279f008a50febebfa9d91c4e3e8448c4d8eda80cbd5c371af"
    sha256 cellar: :any_skip_relocation, sierra:         "9cfafed3ea8980b65d1fa5910db71468b3dfd5b81b598d20ff1bf317c55edbca"
    sha256 cellar: :any_skip_relocation, el_capitan:     "207bd087f9675c188a430ead82700870c9d3088597a788c334d020d92148caa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c89d5ea2923e5399c484b49c2237d198eac9fc624428358ef8a3cf6f8e0e4cf3"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/mairix", "--version"
  end
end
