class Poac < Formula
  desc "Package manager for C/C++"
  homepage "https://github.com/poacpm"
  url "https://github.com/poacpm/poac.git",
      :tag => "0.0.1-beta",
      :revision => "e0edca899587f4cc5ac82874fff2ad66f75e342e"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "curl"
  depends_on "openssl"
  depends_on "yaml-cpp"

  def install
    mkdir "bulid" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    man1.install Dir["docs/man/man1/*.1"]
    bash_completion.install "docs/comp/poac.bash" => "poac"
  end

  test do
    assert_match /Usage/, shell_output("#{bin}/poac --help")
  end
end
