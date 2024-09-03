class AmberLang < Formula
  desc "Programming language that compiles to Bash"
  homepage "https://amber-lang.com/"
  url "https://github.com/amber-lang/amber/releases/download/0.3.4-alpha/source.tar.gz"
  sha256 "26da447d26b1c502b87055fdaae3a62f443e4f0d1c8866e6dca995ee664cc3b4"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # version test
    version_output = shell_output("#{bin}/amber --version")
    assert_includes version_output, "amber 0.3.4-alpha"

    # Functionality test
    functionality_output = shell_output("#{bin}/amber -e 'echo upper(\"hello world!\")'")
    assert_equal "HELLO WORLD!\n", functionality_output
  end
end
