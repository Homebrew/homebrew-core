class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://github.com/clojure/brew-install/releases/download/1.12.3.1577/clojure-tools-1.12.3.1577.tar.gz"
  mirror "https://download.clojure.org/install/clojure-tools-1.12.3.1577.tar.gz"
  sha256 "bbf8513ae88b9873e9781ae86adcb560b81209c66fe94cbe72428af39b1ebacc"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c40319a62a7f5296cd44674e63fd3ae2a770669303df7eabcce5d4e2acbc3a84"
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
