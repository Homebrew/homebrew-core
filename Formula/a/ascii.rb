class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"
  url "https://gitlab.com/esr/ascii/-/archive/3.32/ascii-3.32.tar.bz2"
  sha256 "cde70847d7e91b14cd855addceb1c7a07470a192cb7d178168fa421c1c21c826"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/ascii.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dab01b3541b12d1b64df0115702613b61b57189b5deb21b464bd9316dad77fc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9329415c173e581e5ce702d0bb484d263062c080597ca63274e71830f8db5015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acc5cb46dd2c416305a12540280e8c09bcf5bc9aaf00ffd7ad015ee605904d95"
    sha256 cellar: :any_skip_relocation, sonoma:        "74644cff9063f9317600ef45e8d3d0ff457f944a40f0f6f7481540744a5d19a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4d5665d1967f1b236d23700ffd48d89c8386da50a83511631adc3450734daab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0889952e24a573950f01ab2c9f8c5e292c726f56f9380850f6e47831bf4da20"
  end

  depends_on "asciidoctor" => :build

  def install
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Official name: Line Feed", shell_output("#{bin}/ascii 0x0a")
  end
end
