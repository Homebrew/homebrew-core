class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "8075e180f3b01ff0c290b690488a7628c44b4de12346e04a77d823914a48918b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c5d995cb59c58bb5d44c61bb2d5b88073164561de392e929422c352ef2b2ccef"
    sha256 cellar: :any,                 arm64_sonoma:   "d6f7ec14145cf4230fb6370f48f0daaa1c67cd03a6cda7b22979080714a44b7a"
    sha256 cellar: :any,                 arm64_ventura:  "98bffe2fea54b264392059fff7a0091c7cedc384fdff15cad427eed0390bb5ff"
    sha256 cellar: :any,                 arm64_monterey: "c882077be795e50d065d975928d3ef66636ab05fe1d884968691841cf8919fd2"
    sha256 cellar: :any,                 sonoma:         "d8d54259afc4edb877d269603a16dd4097a95926c92c7008783770006c7617b5"
    sha256 cellar: :any,                 ventura:        "afff6b29de302997785496f4238a3c501e894e6da643228d2dcbbf715285f14e"
    sha256 cellar: :any,                 monterey:       "eec269d68c591c21ad9c4beee25b00e051e3be34f97b94cfa2965b95848315e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "350a9f635cea158f6d0c49b6859dbb91c65e9b4a29c224e34469362e758b9ac5"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system "git", "clone", "https://github.com/extrawurst/gitui.git"
    (testpath/"gitui").cd { system "git", "checkout", "v0.7.0" }

    input, _, wait_thr = Open3.popen2 "script -q screenlog.ansi"
    input.puts "stty rows 80 cols 130"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/gitui -d gitui"
    sleep 1
    # select log tab
    input.puts "2"
    sleep 1
    # inspect commit (return + right arrow key)
    input.puts "\r"
    sleep 1
    input.puts "\e[C"
    sleep 1
    input.close

    screenlog = (testpath/"screenlog.ansi").read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(/\e\[([;\d]+)?m/, "")
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "Sha: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"gitui", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
