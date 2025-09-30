class Mairix < Formula
  desc "Email index and search tool"
  homepage "https://github.com/vandry/mairix"
  url "https://github.com/vandry/mairix/releases/download/0.24/mairix-0.24.tar.gz"
  sha256 "a0702e079c768b6fbe25687ebcbabe7965eb493d269a105998c7c1c2caef4a57"
  license "GPL-2.0-only"
  head "https://github.com/vandry/mairix.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e20af7636ab900ef85118c859bfe53528e668a058a22c1c28b71ad9e9cab0831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4fe9dceecdc765588a0da520eac43995f92e4ee5b0c4c73debba1cc89bf24e26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc607dc417397d6c0d44c2665b7a47528d3db54f7099ae8827b3dafde391fefd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "588fe8d2cc66f1f63c8ba35ed5fed8df99c839cecc867107371c8d8b9741dd8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca582c86e13846ea4d659ae4f63ebb6db21a7199d8ea713c9a764997b05925dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b47d8c878e9315d316c48f8bde023532b8704785cde690f6d1c69e2b92a26787"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab4c27b818c8fb1fe0a160c901822b38023ac7d99c7c7d57fa5a655938989bea"
    sha256 cellar: :any_skip_relocation, ventura:        "fe9fd8565bf77b7f4577330fd55cc019c5fd8e00900326143393c608aacf7264"
    sha256 cellar: :any_skip_relocation, monterey:       "86f72db4522c569ac628e9ef8b726ec4cac27bfd2c06d264070349c1ceb5e3a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "26221ca2d6ce638ad3f47a597a4b67654ecaaa335f54577b380404951733113e"
    sha256 cellar: :any_skip_relocation, catalina:       "3c74d81ccb04da6f3fa9f0f734861738f6dcc924bde12dc8055fd73ea1be68ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "555dfa5bfb9a00a332bcd747b33887ecb72ed2eefcdafc915d88a12a580af7d6"
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
    system bin/"mairix", "--version"
  end
end
