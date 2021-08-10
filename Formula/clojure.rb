class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/clojure-tools-1.10.3.933.tar.gz"
  sha256 "c6c9b4fc7356afc6bfee22d0542f536d4900496bf0fc42376c3d1d30384b6570"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26aac00a02a91e92e220e037ca6c84dcc141b8e2ef16189c4cfc4e84590afd74"
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
