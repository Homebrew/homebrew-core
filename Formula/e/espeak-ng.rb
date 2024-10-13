class EspeakNg < Formula
  desc "Speech synthesizer that supports more than hundred languages and accents"
  homepage "https://github.com/espeak-ng/espeak-ng"
  url "https://github.com/espeak-ng/espeak-ng/archive/refs/tags/1.51.tar.gz"
  sha256 "f0e028f695a8241c4fa90df7a8c8c5d68dcadbdbc91e758a97e594bbb0a3bdbf"
  # NOTE: We omit BSD-2-Clause as getopt.c is only used on Windows
  license "GPL-3.0-or-later"
  head "https://github.com/espeak-ng/espeak-ng.git", branch: "master"

  bottle do
    rebuild 1
    sha256                               arm64_sequoia:  "eeb1cfce58b5deb74cd23d1c29d72ace348cd7cfc76a645c94c090893201b8fb"
    sha256                               arm64_sonoma:   "e65b67177aee6493487968b1532a4ada704eed109c5d8951007df69bfa19dfeb"
    sha256                               arm64_ventura:  "d843709e08e8d930beb0f288fdd1b336d3bd628c63e2c2a812cd09748ac8a19c"
    sha256                               arm64_monterey: "1332045a6452318d5515db38903ecf5d2b9c3aef20719242412236903bf2b0c6"
    sha256                               sonoma:         "d244aff89f55c16198f0171e05ad9d567d21fe7bcacf78703bb840fb86979aec"
    sha256                               ventura:        "7d30840a4c48e5ec210514f1620d9725ce817c447ff24789f32e72650c926add"
    sha256                               monterey:       "582e2c1248240cf7f3126aba521b1aeae3aaa8dc25e19905f4f485da85245b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42b6e4106a6a557f8f93622f5772e52398664b346fca36e165db10af96c6a8d0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcaudiolib"

  conflicts_with "espeak", because: "both install `espeak` binaries"

  def install
    touch "NEWS"
    touch "AUTHORS"
    touch "ChangeLog"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    # Real audio output fails on macOS CI runner, maybe due to permissions
    audio_output = if OS.mac? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      "AUDIO_OUTPUT_RETRIEVAL"
    else
      "AUDIO_OUTPUT_PLAYBACK"
    end

    (testpath/"test.cpp").write <<~EOS
      #include <espeak/speak_lib.h>
      #include <iostream>
      #include <cstring>

      int main() {
        std::cout << "Initializing espeak-ng..." << std::endl;

        espeak_POSITION_TYPE position_type = POS_CHARACTER;
        espeak_AUDIO_OUTPUT output = #{audio_output};
        int options = 0;
        void* user_data = nullptr;
        unsigned int* unique_identifier = nullptr;

        espeak_Initialize(output, 500, nullptr, options);
        espeak_SetVoiceByName("en");

        const char *text = "Hello, Homebrew test successful!";
        size_t text_length = strlen(text) + 1;
        std::cout << "Synthesizing speech..." << std::endl;
        espeak_Synth(text, text_length, 0, position_type, 0, espeakCHARS_AUTO, unique_identifier, user_data);
        espeak_Synchronize();
        espeak_Terminate();

        std::cout << "espeak-ng terminated successfully." << std::endl;

        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lespeak-ng", "-o", "test"
    system "./test"
  end
end
