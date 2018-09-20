class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/v1.0.1.tar.gz"
  sha256 "c08ef670d472eb6fd50a2f863c6a4432b2963addd47f35d54cfb9fd7c543895b"
  head "https://github.com/nanomsg/nng.git"

  option "with-docs", "Include man pages in install"
  option "with-test", "Run tests after building"
  option "with-shared-library", "Build as a shared library instead of static"

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    args = std_cmake_args + ["-GNinja"]
    args << "-DNNG_ENABLE_DOC=ON" if build.with? "docs"
    args << "-DBUILD_SHARED_LIBS=ON" if build.with? "shared-library"

    mkdir "build" do
      system "cmake", "..", *args
      system "ninja"
      system "ninja", "test" if build.with? "test"
      system "ninja", "install"
    end
  end

  test do
    bind = "tcp://127.0.0.1:8000"

    pid = fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    begin
      output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
      assert_match /home/, output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
