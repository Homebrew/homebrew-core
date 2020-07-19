class Forego < Formula
  desc "Foreman in Go for Procfile-based application management"
  homepage "https://github.com/ddollar/forego"
  url "https://github.com/ddollar/forego/archive/20180216151118.tar.gz"
  sha256 "23119550cc0e45191495823aebe28b42291db6de89932442326340042359b43d"
  license "Apache-2.0"
  head "https://github.com/ddollar/forego.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3004f019d2361f0831bcd83d6f7f6d581f666be9c8a5a6e0a3b81f84d3170146" => :catalina
    sha256 "c4386b61dae5a4c4cae32db529099221663de4acb42db78e6daca3e5c018a31d" => :mojave
    sha256 "5a855ce2b4f4bd2349b6814c11ec85f788a9be510aff4f18df582141dbc15295" => :high_sierra
    sha256 "5a4b9261fb91507df08c7c840134a21effb2b407aa5e84474b2900f8d436f3ca" => :sierra
    sha256 "77720ca90705c26a92248cd822d4a3b0cef329c5b16e2da62a7815cfd61f0ce2" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ddollar/forego").install buildpath.children
    cd "src/github.com/ddollar/forego" do
      system "go", "build", "-o", bin/"forego", "-ldflags",
             "-X main.Version=#{version} -X main.allowUpdate=false"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Procfile").write "web: echo \"it works!\""
    assert_match "it works", shell_output("#{bin}/forego start")
  end
end
