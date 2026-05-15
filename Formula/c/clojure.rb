class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://github.com/clojure/brew-install/releases/download/1.12.5.1638/clojure-tools-1.12.5.1638.tar.gz"
  mirror "https://download.clojure.org/install/clojure-tools-1.12.5.1638.tar.gz"
  sha256 "7807e1034441cae43c21d8a026c1d8a2d20f63f90398b8034470b0e2e1f31791"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e4c7e03dba2093927027a9f037d2890cc87c2a2095b55fdf52eb9494d02a34d8"
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
    system("#{bin}/clj", "-e", "nil")
    %w[clojure clj].each do |clj|
      assert_equal "2", shell_output("#{bin}/#{clj} -e \"(+ 1 1)\"").strip
    end
  end
end
