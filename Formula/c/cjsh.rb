class Cjsh < Formula
  desc "CJ's Shell"
  homepage "https://github.com/CadenFinley/CJsShell"
  url "https://github.com/CadenFinley/CJsShell.git",
      tag:      "2.0.3.0",
      revision: "5bc1e4209526b00852a8fd674553b5cbe4df4b0c"
  version "2.0.3.0"

  license "MIT"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "curl"
  depends_on "nlohmann-json"

  def install
    mkdir "build" do
      system "cmake", "..",
             "-DCMAKE_BUILD_TYPE=Release",
             "-DCMAKE_INSTALL_PREFIX=#{prefix}",
             "-DCMAKE_PREFIX_PATH=#{Formula["openssl@3"].opt_prefix}",
             *std_cmake_args
      system "make"
      bin.install "cjsh"
    end
  end

  def post_install
    original_shell = ENV["SHELL"]
    (prefix/"original_shell.txt").write original_shell
  end

  def post_uninstall
    original = (prefix/"original_shell.txt").read.chomp rescue nil
    return if original.to_s.empty?
    ohai "Restoring your original shell to #{original}"
    safe_system "sudo", "chsh", "-s", original, ENV["USER"]
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
