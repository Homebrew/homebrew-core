class Cjsh < Formula
  desc "CJ's Shell"
  homepage "https://github.com/CadenFinley/CJsShell"
  url "https://github.com/CadenFinley/CJsShell.git",
      tag:      "2.0.3.1",
      revision: "22fcd2ef9ed81c36df7df369de30f06878db1db0"
  version "2.0.3.1"

  license "MIT"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "curl"
  depends_on "nlohmann-json"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DCMAKE_PREFIX_PATH=#{Formula["openssl@3"].opt_prefix}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    original_shell = ENV["SHELL"]
    (prefix/"original_shell.txt").write original_shell
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/cjsh --version")
  end

  def caveats
    <<~EOS
      CJ's Shell
      To set as your default shell run 'cjsh --set-as-shell'
      To see the help menu run 'cjsh --help'
      To launch cjsh as a login shell run 'cjsh --login'
    EOS
  end
end
