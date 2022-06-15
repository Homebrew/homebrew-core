class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.3.5.tar.gz"
  sha256 "0d131695e5b7b4d569a5aee6bdd9830fa4400a24b7d5642c95a2857007177da7"
  license "Apache-2.0"
  head "https://github.com/poacpm/poac.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on macos: :big_sur # C++20
  depends_on "openssl@1.1"
  depends_on "spdlog"

  uses_from_macos "libarchive"

  on_linux do
    depends_on "gcc"
  end
  fails_with gcc: "5" # C++20

  def install
    system "cmake", "-B", "build", "-DCPM_USE_LOCAL_PACKAGES=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    man1.install (buildpath/"src/etc/man/man1").children
    bash_completion.install_symlink "src/etc/poac.bash" => "poac"
    zsh_completion.install_symlink "src/etc/poac.bash" => "_poac"
  end

  test do
    system bin/"poac", "create", "hello_world"
    cd "hello_world" do
      assert_match "Hello, world!", shell_output("#{bin}/poac run")
    end
  end
end
