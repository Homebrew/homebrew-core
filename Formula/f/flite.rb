class Flite < Formula
  desc "Small fast and portable speech synthesis system"
  homepage "http://www.festvox.org/flite"
  url "https://github.com/festvox/flite/archive/refs/tags/v2.2.tar.gz"
  sha256 "ab1555fe5adc3f99f1d4a1a0eb1596d329fd6d74f1464a0097c81f53c0cf9e5c"
  # The `:cannot_represent` is for:
  # * Sun Microsystems, Inc. license (e.g. src/speech/g72x.c)
  # * BSD license with 2 clauses but not matching BSD-2-Clause (e.g. src/speech/rateconv.c)
  license all_of: ["MIT-Festival", "BSD-2-Clause", "BSD-3-Clause", "Spencer-86", "Apache-2.0", :cannot_represent]
  head "https://github.com/festvox/flite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1efab899bba7f6bec83d5f8db07dcbe12cb6af0f48d84dca73240ac3b483091"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3804878f6959a164a1632be059ddd81724d27ab50d7b161e39a90586b205c30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f7b38be2ec732d9403ab2c36a8b63a61c6b6cf483e34893d7128091918fb0db"
    sha256 cellar: :any_skip_relocation, sonoma:        "c406840db471902ddcb42c550902780eac81fd556ef9de558665285a7c74523f"
    sha256 cellar: :any,                 arm64_linux:   "30dd78b1e766610db27b9b5d06b5b44ec7ea7adf87d612f12484eaeecb40a064"
    sha256 cellar: :any,                 x86_64_linux:  "ef004c41ee3f0dca395db755b249d669d12b7f49164617254521a21abdeb95d2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Workaround a bug for macOS build. See https://github.com/festvox/flite/pull/21
  on_macos do
    depends_on "coreutils" => :build
  end

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?

    system "./configure", "--disable-silent-rules",
                        "--with-lex",
                        "--with-vox",
                        *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"flite", "-t", "Hello, Homebrew!", "test.wav"
    assert_path_exists testpath/"test.wav"
  end
end
