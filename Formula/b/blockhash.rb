class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "3c48af7bdb1f673b2f3c9f8c0bfa9107a7019b54ac3b4e30964bc0707debdd3a"
  license "MIT"
  revision 4
  head "https://github.com/commonsmachinery/blockhash.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67363b29a30df42d320f72595bd81ce0dc7e41ec7cf0ec5f620bc90e6256a681"
    sha256 cellar: :any,                 arm64_sequoia: "da404e78c996ce8a8cc0f39fb53c7b98de1df04a20f3f04224ef34d181d427e1"
    sha256 cellar: :any,                 arm64_sonoma:  "570d07a44d4c376152581378e09887c872ff761622c559dce4018466cb964c69"
    sha256 cellar: :any,                 arm64_ventura: "702e383c365b207cb2100d72858ce30f40535e68122958bbb983d5f40052ebcd"
    sha256 cellar: :any,                 sonoma:        "549ec4cab23c30f91e09ac9bb552be96444915ded6cf8b038e215cb7a0396b16"
    sha256 cellar: :any,                 ventura:       "45c797c6b7554516ad75039b09aea8531253ab81c1a958bf55a1710fc0de5be2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04e18532865185d071a00a063393586fe2af100b84f8e2124b230a5185504bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5281622fbde0603ec516b153e1a02e85d58e18c0074e4a6bc2b7df5670784aee"
  end

  depends_on "pkgconf" => :build
  depends_on "imagemagick"

  uses_from_macos "python" => :build

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    # pkg-config adds -fopenmp flag during configuring
    # This fails the build on system clang, and OpenMP is not used in blockhash
    inreplace "build/c4che/_cache.py", "-fopenmp", ""
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
      sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
    end

    resource("homebrew-testdata").stage testpath
    hash = "00007ff07ff07fe07fe67ff07560600077fe701e7f5e000079fd40410001ffff"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end
