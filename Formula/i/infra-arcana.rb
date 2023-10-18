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

    chdir "build" do
      system "make", "ia"
      system "make", "install"
    end

    libexec.install "build/target/ia/audio",
      "build/target/ia/data",
      "build/target/ia/gfx",
      "build/target/ia/ia",
      "build/target/ia/manual.txt"

    # The game has to be run from the directory the executable is in, so we
    # can't just use `write_exec_script`.
    # See https://gitlab.com/martin-tornqvist/ia/-/issues/231#note_651387435
    (bin/"infra-arcana").write <<~EOS
      #!/bin/bash
      cd "#{libexec}" && exec ./ia "$@"
    EOS

    prefix.install "build/target/ia/LICENSE.txt",
      "build/target/ia/LICENSE-AUDIO.txt",
      "build/target/ia/LICENSE-FONTS.txt",
      "build/target/ia/LICENSE-FONT-DEJAVU.txt",
      "build/target/ia/LICENSE-FONT-SPECIAL-ELITE.txt"

    doc.install "build/target/ia/contact.txt",
      "build/target/ia/credits.txt",
      "build/target/ia/release_history.txt"
  end

  test do
    # The game exits with an error because it can't read an XML file when it's
    # launched from outside of the directory the executable is in.
    # We intentionally trigger this error and thus assert that the executable
    # is (hopefully) working as expected.

    (testpath/"expected_error.txt").write <<~EOS
      ERROR: Failed to find or read xml file at: data/colors/colors.xml
      tinyxml2 reported error: XML_ERROR_FILE_NOT_FOUND
    EOS

    (testpath/"launch_with_error.sh").write <<~EOS
      #!/bin/bash
      "#{libexec}/ia" || true
    EOS

    chmod("+x", "launch_with_error.sh")

    system "./launch_with_error.sh > actual_error.txt 2>&1"

    assert_equal shell_output("cat expected_error.txt").strip,
      shell_output("cat actual_error.txt").strip
  end
end
