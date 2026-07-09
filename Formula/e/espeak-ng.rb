class EspeakNg < Formula
  desc "Speech synthesizer that supports more than hundred languages and accents"
  homepage "https://github.com/espeak-ng/espeak-ng"
  url "https://github.com/espeak-ng/espeak-ng/archive/refs/tags/1.52.0.tar.gz"
  sha256 "bb4338102ff3b49a81423da8a1a158b420124b055b60fa76cfb4b18677130a23"
  # NOTE: We omit BSD-2-Clause as getopt.c is only used on Windows
  license "GPL-3.0-or-later"
  head "https://github.com/espeak-ng/espeak-ng.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "6e937d9aa97fead6b24f70f09e48a6f769db48efa4d9fd7a52b2b7a7ccd2b6f4"
    sha256                               arm64_sequoia: "330873deca13228ec98927f86fb4e18e990e8707f888aaf665b6e12a55efaf47"
    sha256                               arm64_sonoma:  "1e23d2b57e90a15d4a15f413bb81af1af843a27083b753d8d76a70d9a40c666c"
    sha256                               arm64_ventura: "99c2519104e4462e0e6a6727494c64b5892e60d75ac4c69e49a65c7aa02428de"
    sha256                               sonoma:        "aa796417d69f834ad2373129c6e30e06e97e6857c45ea8a483eda49815aee65e"
    sha256                               ventura:       "f125b94acc7e862d31c649810ecaea2636c5bbd67b0fe52f37a05ddb799f62c5"
    sha256                               arm64_linux:   "b99673a1da4dbd730d237bf31ffbceccbe700792e7d8b5d0b7ddcbcf5ab6254d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b038b1ea4b677dec8ddb98c16a84ae3985cab968dc60aff22a1c4a02beba6236"
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

    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lespeak-ng", "-o", "test"
    system "./test"
  end
end
