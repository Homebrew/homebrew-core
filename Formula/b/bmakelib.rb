class Bmakelib < Formula
  desc "A minimalist standard library for writing Makefiles."
  homepage "https://github.com/bahmanm/bmakelib"
  url "https://github.com/bahmanm/bmakelib/releases/download/v0.4.1/bmakelib-0.4.1.tar.gz"
  sha256 "d60a6b0674941bee801571677fa3d6e09f9d85835ec9f790b5f040feed0eada6"
  license "Apache-2.0"

  depends_on "make" => :build
  depends_on "perl" => :build

  depends_on "make"
  depends_on "perl"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    mktemp('bmakelib') {
      File.write(
        'Makefile',
        ["include bmakelib/bmakelib.mk",
         "PHONY:echo-version",
         "echo-version:",
         "\t@echo $(bmakelib.VERSION)"].join("\n"))
      assert_equal '0.4.1', shell_output('make -I ${HOMEBREW_PREFIX}/include echo-version').strip
    }
  end
end
