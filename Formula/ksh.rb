class Ksh < Formula
  desc "KornShell, ksh93"
  homepage "http://www.kornshell.com"
  url "https://github.com/att/ast/releases/download/2020.0.0-alpha1/ksh-2020.0.0-alpha1.tar.gz"
  version "2020.0.0.1-alpha"
  sha256 "48b150392038b0592bd0b07817ff4838dc038f53bb564d4a73a35357fc88802e"

  depends_on "meson" => :build
  depends_on "ninja" => :build

  resource "init" do
    url "https://github.com/att/ast/releases/download/2020.0.0-alpha1/ksh-2020.0.0-alpha1.tar.gz"
    sha256 "48b150392038b0592bd0b07817ff4838dc038f53bb564d4a73a35357fc88802e"
  end

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def caveats
    <<~EOS
      We agreed to the Eclipse Public License 1.0 for you.
      If this is unacceptable you should uninstall.
    EOS
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/ksh -e 'echo Hello World!'").chomp
  end
end
