class Dvanalyzer < Formula
  desc "Quality control tool for examining tape-to-file DV streams"
  homepage "https://mediaarea.net/DVAnalyzer"
  url "https://mediaarea.net/download/binary/dvanalyzer/1.4.2/DVAnalyzer_CLI_1.4.2_GNU_FromSource.tar.bz2"
  sha256 "d2f3fdd98574f7db648708e1e46b0e2fa5f9e6e12ca14d2dfaa77c13c165914c"
  license all_of: ["BSD-2-Clause", "GPL-3.0-or-later", "Zlib"]

  livecheck do
    url "https://mediaarea.net/DVAnalyzer/Download/Source"
    regex(/href=.*?dvanalyzer[._-]?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8bb414e0719a71fcc95ea8c1351f983fa7df1d0a3c350182c9be47b8064fefc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92eda7b054009d95d846a8a4cebf111bd26eb9b4340d5548489ed4645b6fd667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ea8f647c562fd62ed7acc15cb685dc8445b90168ddbb6013199e8feb8337738"
    sha256 cellar: :any_skip_relocation, sonoma:        "309bb248ed85a89a2a03562dabb9b3e97c2c24b3f0a81dd8f51cf2511c1e380a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f25ff17a0c20c42a7b826e116d5c5687354980a75c403026c2b732f27180b597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a381c4467638323d1c9ab03fca279140ee97c76c99a3894c59b10757bfe1c711"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--enable-static",
              "--disable-shared"]
      system "./configure", *args
      system "make"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--enable-static",
              "--disable-shared"]
      system "./configure", *args
      system "make"
    end

    cd "AVPS_DV_Analyzer/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--enable-staticlibs", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    test_mp3 = test_fixtures("test.mp3")
    output = shell_output("#{bin}/dvanalyzer --Header #{test_mp3}")
    assert_match test_mp3.to_s, output

    assert_match version.to_s, shell_output("#{bin}/dvanalyzer --Version")
  end
end
