class Mkvalidator < Formula
  desc "Tool to verify Matroska and WebM files for spec conformance"
  homepage "https://www.matroska.org/downloads/mkvalidator.html"
  url "https://downloads.sourceforge.net/project/matroska/mkvalidator/mkvalidator-0.5.2.tar.bz2"
  sha256 "2e2a91062f6bf6034e8049646897095b5fc7a1639787d5fe0fcef1f1215d873b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8ed0ae48b3922549518802148f3687a9bcab9f072624d619e077368a874e71b" => :mojave
    sha256 "5f0c85894cd7d4a7c5cdce1e26c5cc7c15ac7baa6c32a63e3474632f7727d8af" => :high_sierra
    sha256 "5f0c85894cd7d4a7c5cdce1e26c5cc7c15ac7baa6c32a63e3474632f7727d8af" => :sierra
    sha256 "6c253cdf3c824b6e37af7cca51bf05a930785286bc83ec367e10500d9645519c" => :el_capitan
  end

  resource "tests" do
    url "https://github.com/dunn/garbage/raw/c0e682836e5237eef42a000e7d00dcd4b6dcebdb/test.mka"
    sha256 "6d7cc62177ec3f88c908614ad54b86dde469dbd2b348761f6512d6fc655ec90c"
  end

  def install
    ENV.deparallelize # Otherwise there are races

    # Reported 2 Nov 2017 https://github.com/Matroska-Org/foundation-source/issues/31
    inreplace "configure", "\r", "\n"

    system "./configure"
    system "make", "-C", "mkvalidator"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install "release/#{bindir}/mkvalidator"
  end

  test do
    resource("tests").stage do
      system bin/"mkvalidator", "test.mka"
    end
  end
end
