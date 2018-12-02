class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/v1.1.1.tar.gz"
  sha256 "cec54ed40c8feb5c0c66f81cfd200e9b243639a75d1b6093c95ee55885273205"

  bottle do
    sha256 "95806f0fd6dda2f2d07657186fe0fd5b67d0df560797806165c2a133f4e31e72" => :mojave
    sha256 "7afc683e8993ddc89b5e0bbede86b8967453bb90253b5970e086feef4b08019d" => :high_sierra
    sha256 "6b5464df0896b155b61b0f0428956142d0deabebd75e71f7116b5558a5138556" => :sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-GNinja", "-DNNG_ENABLE_DOC=ON", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "ninja"
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
      assert_match(/home/, output)
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
