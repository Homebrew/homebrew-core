class EspeakNg < Formula
  desc "Speech synthesizer that supports more than hundred languages and accents"
  homepage "https://github.com/espeak-ng/espeak-ng"
  url "https://github.com/espeak-ng/espeak-ng/archive/refs/tags/1.51.tar.gz"
  sha256 "f0e028f695a8241c4fa90df7a8c8c5d68dcadbdbc91e758a97e594bbb0a3bdbf"
  license all_of: ["GPL-3.0-or-later", "BSD-2-Clause"]
  head "https://github.com/espeak-ng/espeak-ng.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "0a7e95c227995346735e241f7e405e1674fe3ffc2cd34dc0652b0759cf4e4e79"
    sha256                               arm64_ventura:  "2ca85163fc22f4cbe289470309515a64644330088677dbfc52af0f9adf01f63e"
    sha256                               arm64_monterey: "41c21e4d913066d098a03b0868560cf8dfd9c79536742f0f3ce7045d011e52d4"
    sha256                               sonoma:         "66799720066a97ad3d683287919e83d99a95ec4ce8598c5f39fd6d9360801afc"
    sha256                               ventura:        "c03369a85157c551b4f508bdae1c8501c1956f6ef4a6ebd6b090071e898597f8"
    sha256                               monterey:       "0fce21cfbd719886ce37847283bdfef19d84e8409fe684735142e7df5102a696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1be82b0f888a00ba2cf6b273bb2eb045431a4bbafe5c0a2dd1b982e8d39b7132"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    touch "NEWS"
    touch "AUTHORS"
    touch "ChangeLog"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <espeak/speak_lib.h>
      #include <iostream>
      #include <cstring>

      int main() {
        std::cout << "Initializing espeak-ng..." << std::endl;

        espeak_POSITION_TYPE position_type = POS_CHARACTER;
        espeak_AUDIO_OUTPUT output = AUDIO_OUTPUT_PLAYBACK;
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
