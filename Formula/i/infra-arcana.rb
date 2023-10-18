class InfraArcana < Formula
  desc "Roguelike set in the early 20th century"
  homepage "https://sites.google.com/site/infraarcana/"
  url "https://gitlab.com/martin-tornqvist/ia/-/archive/v22.1.0/ia-v22.1.0.tar.gz"
  sha256 "3a2d05ece62fdef51e8515004f0412ac825b0621ab81dc918240c6c04d68c96f"
  license "AGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install "target/ia/audio",
      "target/ia/data",
      "target/ia/gfx",
      "target/ia/ia",
      "target/ia/manual.txt"

    # The game has to be run from the directory the executable is in, so we
    # can't just use `write_exec_script`.
    # See https://gitlab.com/martin-tornqvist/ia/-/issues/231#note_651387435
    (bin/"infra-arcana").write <<~EOS
      #!/bin/bash
      cd "#{libexec}" && exec ./ia "$@"
    EOS

    prefix.install "target/ia/LICENSE.txt",
      "target/ia/LICENSE-AUDIO.txt",
      "target/ia/LICENSE-FONTS.txt",
      "target/ia/LICENSE-FONT-DEJAVU.txt",
      "target/ia/LICENSE-FONT-SPECIAL-ELITE.txt"

    doc.install "target/ia/contact.txt",
      "target/ia/credits.txt",
      "target/ia/release_history.txt"
  end

  test do
    # The game exits with an error because it can't read an XML file when it's
    # launched from outside of the directory the executable is in.
    # We intentionally trigger this error and thus assert that the executable
    # is (hopefully) working as expected.

    ENV["SDL_AUDIODRIVER"] = "dummy"

    assert_equal "
ERROR: Failed to find or read xml file at: data/colors/colors.xml
tinyxml2 reported error: XML_ERROR_FILE_NOT_FOUND
      ".strip, shell_output("#{libexec}/ia 2>&1 >/dev/null", 1).strip
  end
end
