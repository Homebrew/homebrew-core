class Fpart < Formula
  desc "Sorts file trees and packs them into bags"
  homepage "https://github.com/martymac/fpart/"
  url "https://github.com/martymac/fpart/archive/fpart-1.5.1.tar.gz"
  sha256 "c353a28f48e4c08f597304cb4ebb88b382f66b7fabfc8d0328ccbb0ceae9220c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8ecdc9f7c43d11b56c029ceccde704c4c98618bbfdfd405b8a2dcc35833ac8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db5a886321791a33f3e679280e1d812156af73deb294b984ff4468af7eed7a10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0b6d774190137f2f44e20f594c610bb3dc0308c9a313505a547ab39e962452a"
    sha256 cellar: :any_skip_relocation, ventura:        "d99c4782728cf17322298566a4342023aa39d107f8b97f48a77e398523c63aab"
    sha256 cellar: :any_skip_relocation, monterey:       "3f7c5691c929f24e06922155c88992dc768cd94d0e92a3ea5d96b2f55239e790"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb78bb4299fbc16a5a5452743b6b4e09837bddc40b533190552f7b6fa4d115d7"
    sha256 cellar: :any_skip_relocation, catalina:       "75c5ab16ce182a2bd39e354dec76cb7086561eb81682c8b637c02c6d95b0455d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd14bb6efbfb1038569a270fcffc5e28817ea3f9334c1c63e0ea6cbeb28c0a9e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"myfile1").write("")
    (testpath/"myfile2").write("")
    system bin/"fpart", "-n", "2", "-o", (testpath/"mypart"), (testpath/"myfile1"), (testpath/"myfile2")
    assert_predicate testpath/"mypart.1", :exist?
    assert_predicate testpath/"mypart.2", :exist?
    refute_predicate testpath/"mypart.0", :exist?
    refute_predicate testpath/"mypart.3", :exist?
  end
end
