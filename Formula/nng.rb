class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/v1.1.1.tar.gz"
  sha256 "cec54ed40c8feb5c0c66f81cfd200e9b243639a75d1b6093c95ee55885273205"

  bottle do
    sha256 "a83f86c54b322fce731e110ad4e18a2b75ca80ec90ec9e421b0b2bbfb5c277f6" => :mojave
    sha256 "612ede782031edcf87d5874b58e27665402e666071702fbaf997704dbd60e1e5" => :high_sierra
    sha256 "4e368f3c442670680d4dbe67ee5305e04059573fc48f43fcde95c5988694a925" => :sierra
    sha256 "b2833f010a330ac4730659b6b8422b5d9fd9c251284987321a7d052bdd8d41f6" => :el_capitan
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
