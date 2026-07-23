class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://github.com/clojure/brew-install/releases/download/1.12.5.1654/clojure-tools-1.12.5.1654.tar.gz"
  mirror "https://download.clojure.org/install/clojure-tools-1.12.5.1654.tar.gz"
  sha256 "dc86cc56bc372fcef07bd87f44693eeb4b61cf5f44347883878364d03b5fb342"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "545acfab6a4ed81bebb77f01b6b7e51e6dced06980a686220c98e9e259c68c4c"
  end

  depends_on "openjdk"
  depends_on "rlwrap"

  uses_from_macos "ruby" => :build

  def install
    system "./install.sh", prefix
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    ENV["TERM"] = "xterm"
    assert_equal "2", shell_output("#{bin}/clojure -e \"(+ 1 1)\"").strip

    require "io/console"
    require "pty"
    # `clj` wraps clojure with rlwrap, which needs a sized tty
    PTY.spawn("#{bin}/clj -e '(* 6 7)' > out") do |r, _w, pid|
      r.winsize = [24, 80]
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end
    assert_match "42", (testpath/"out").read
  end
end
