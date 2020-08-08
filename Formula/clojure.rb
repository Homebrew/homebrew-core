class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/clojure-tools-1.10.1.636.tar.gz"
  sha256 "f3a962954a6e45b0f35e2f61c8c10e93dbff469766a57d3cbeb667cb0ea7b2ea"
  license "EPL-1.0"

  bottle :unneeded

  depends_on "openjdk"
  depends_on "rlwrap"

  uses_from_macos "ruby" => :build

  def install
    system "./install.sh", prefix
    bin.env_script_all_files libexec/"bin", JAVA_HOME: "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    ENV["TERM"] = "xterm"
    system("#{bin}/clj", "-e", "nil")
    %w[clojure clj].each do |clj|
      assert_equal "2", shell_output("#{bin}/#{clj} -e \"(+ 1 1)\"").strip
    end
  end
end
