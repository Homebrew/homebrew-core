class Execline < Formula
  desc "Interpreter-less scripting language"
  homepage "https://skarnet.org/software/execline/"
  url "https://skarnet.org/software/execline/execline-2.9.9.2.tar.gz"
  sha256 "908ed4db3a6b3a23a205d8fd4cf2a71089156f2aeae0f54656045aafad2dee32"
  license "ISC"
  head "git://git.skarnet.org/execline", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a34cd2a4118064e562ccf4129012601a1ff827035231835e244613520f04c055"
    sha256 cellar: :any, arm64_sequoia: "0c821be5ea7210ce575c0dd8dd4555e6f3766192b9ef41a4fb6867461340afc0"
    sha256 cellar: :any, arm64_sonoma:  "2ff69fef93dc99840fc3a50dc662e2cb9ed039f7f839f17ab53b6367da20d20f"
    sha256 cellar: :any, sonoma:        "eac033e7d68f6c016a461d3fb5887b2c3d65a70775626fb94cdcdc644dbe26d5"
    sha256 cellar: :any, arm64_linux:   "de8756b61cd6846ca05ba613ac1ec33c268bf43ee21ea3be1ee5af4dc1c5ea19"
    sha256 cellar: :any, x86_64_linux:  "6834735c20cd94e60855b47878af70c619ed11eb2b5bd274b25e64c02652a621"
  end

  depends_on "pkgconf" => :build
  depends_on "skalibs"

  def install
    args = %W[
      --disable-silent-rules
      --enable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{formula_opt_bin("pkgconf")}/pkg-config
      --with-sysdeps=#{formula_opt_lib("skalibs")}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.eb").write <<~EOS
      foreground
      {
        sleep 1
      }
      "echo"
      "Homebrew"
    EOS
    assert_match "Homebrew", shell_output("#{bin}/execlineb test.eb")
  end
end
