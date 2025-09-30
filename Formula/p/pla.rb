class Pla < Formula
  desc "Tool for building Gantt charts in PNG, EPS, PDF or SVG format"
  homepage "https://www.arpalert.org/pla.html"
  url "https://github.com/thierry-f-78/pla/archive/refs/tags/1.3.tar.gz"
  sha256 "966ff0de604cfe4fe6e9650ee7776c5096211ad76e060ff4fd9edbd711977ef2"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "daa4f5dec64b4beba34a971523cc108879bc605eb20d0f69cbb9bbcea837b424"
    sha256 cellar: :any,                 arm64_sequoia:  "bb80455464cd182092c87cc0c242eda1050fdb3579ac6204338934741c5af632"
    sha256 cellar: :any,                 arm64_sonoma:   "34622b25b182676b0af0bcb5832d47a7d72672d3ad6e972036efdb551011fa7e"
    sha256 cellar: :any,                 arm64_ventura:  "7be71e6a234104ac6da8b3fdbf000f04345d08c4e1ba933bf736833628e1c415"
    sha256 cellar: :any,                 arm64_monterey: "f335f954b419f71258a566f1abee2db8211f21aee91bb98f1c97ea8d42e48761"
    sha256 cellar: :any,                 arm64_big_sur:  "2cf83294bbf3d2bd6679e81eb248c588a413ddeadac46ceb24de6affb368aa06"
    sha256 cellar: :any,                 sonoma:         "0f45496b905bbfe8c259e01559fb2a2b4a1675bc211b80af5c5b62b4a5cf132d"
    sha256 cellar: :any,                 ventura:        "326cc1c21ff09f02478fc21e8a9050c413c5a6d233e53a49920bc8b0fde09b83"
    sha256 cellar: :any,                 monterey:       "0787de036e4a83bc03c2153ec4f447d187d6382c5bbf55f19cefb96488412b1a"
    sha256 cellar: :any,                 big_sur:        "a40094ed802100f73d1ba8fedf5e536649c7fcae1e8a1bed9e240abdc690f221"
    sha256 cellar: :any,                 catalina:       "9f16be821eecfd9fdc72071f1c2071790904f06ca56c0cf106021e7a1f4c8342"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "64bb6856b07419d9cab8f02202a2410766c5da793d41d71f3464f20775e64175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9d8b9816ad19faa6e3fafc3c461124f00a9633ef3c22d4c66c589f25395d60e"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"

  def install
    # Ubuntu-specific fix to add --no-as-needed linker flag on Linux.
    inreplace "Makefile", "LDFLAGS = -lm", "LDFLAGS = -lm -Wl,--no-as-needed" if OS.linux?
    system "make"
    bin.install "pla"
  end

  test do
    (testpath/"test.pla").write <<~EOS
      [4] REF0 Install des serveurs
        color #8cb6ce
        child 1
        child 2
        child 3

        [1] REF0 Install 1
          start 2010-04-08 01
          duration 24
          color #8cb6ce
          dep 2
          dep 6
    EOS
    system bin/"pla", "-i", "#{testpath}/test.pla", "-o test"
  end
end
