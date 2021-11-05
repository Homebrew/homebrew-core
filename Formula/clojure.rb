class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/clojure-tools-1.10.3.1020.tar.gz"
  sha256 "55654c3cbffd73a3b15e6112e2c1908170f690c14d8da9280beea826f5a604e2"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "16559983e154d0efa4f36ea2b58d5dcaf52c3a1890481275f5a12f13fbdb9ee8"
    sha256 cellar: :any_skip_relocation, big_sur:       "16559983e154d0efa4f36ea2b58d5dcaf52c3a1890481275f5a12f13fbdb9ee8"
    sha256 cellar: :any_skip_relocation, catalina:      "16559983e154d0efa4f36ea2b58d5dcaf52c3a1890481275f5a12f13fbdb9ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2392e4c09fc15cb976b919dcb1708a62d906e86ed48697effdf2fb2b0027074"
    sha256 cellar: :any_skip_relocation, all:           "80fa694a5c5db974a80b51c101370775083350d670a1073fe5406d3caa3a7787"
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
