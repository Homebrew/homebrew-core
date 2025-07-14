class Mallet < Formula
  desc "MAchine Learning for LanguagE Toolkit"
  homepage "https://mimno.github.io/Mallet/index"
  # We use the zip as the 202108 tarball was generated with macOS metadata so
  # it is unpacked incorrectly on Linux and prevents `all` bottle creation
  url "https://github.com/mimno/Mallet/releases/download/v202108/Mallet-202108-bin.zip"
  sha256 "874e682add31d638fb6b97c0ad485ff8fbc45e08c47305843139604b7dc15f62"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2a79370bb96c6b93c4e5ccea01dfd09deeea7bcd7410c34ebfbd0584e24939e3"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.{bat,dll,exe}"] # Remove all windows files

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/mimno/Mallet/master/sample-data/stackexchange/tsv/testing.tsv"
      sha256 "06b4a0b3f27afa532ded841e8304449764a604fb202ba60eb762eaa79e9e02f3"
    end

    resource("homebrew-testdata").stage do
      system bin/"mallet", "import-file", "--input", "testing.tsv", "--keep-sequence"
      assert_equal "seconds",
        shell_output("#{bin}/mallet train-topics --input text.vectors " \
                     "--show-topics-interval 0 --num-iterations 100 2>&1").split.last
    end
  end
end
