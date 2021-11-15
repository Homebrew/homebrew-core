class Forego < Formula
  desc "Foreman in Go for Procfile-based application management"
  homepage "https://github.com/ddollar/forego"
  url "https://github.com/ddollar/forego/archive/20180216151118.tar.gz"
  sha256 "23119550cc0e45191495823aebe28b42291db6de89932442326340042359b43d"
  license "Apache-2.0"
  head "https://github.com/ddollar/forego.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "add9895abd190b3c092406ff31939139d7f4e84ea4b8826a3e81e701ce5a482f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae42636ee209a05effd8db31e34d9458bac997f778227eb9bab935fc3699f3fa"
    sha256 cellar: :any_skip_relocation, monterey:       "cc406f5189dfc536b2cf7cc3e9bdbc955717630027770be5c73f8684ca607a5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aa5d4a73ba9ec2d2905bac72b65166394c33d7f6ade2cd842d7e7eeceaedd34"
    sha256 cellar: :any_skip_relocation, catalina:       "3004f019d2361f0831bcd83d6f7f6d581f666be9c8a5a6e0a3b81f84d3170146"
    sha256 cellar: :any_skip_relocation, mojave:         "c4386b61dae5a4c4cae32db529099221663de4acb42db78e6daca3e5c018a31d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5a855ce2b4f4bd2349b6814c11ec85f788a9be510aff4f18df582141dbc15295"
    sha256 cellar: :any_skip_relocation, sierra:         "5a4b9261fb91507df08c7c840134a21effb2b407aa5e84474b2900f8d436f3ca"
    sha256 cellar: :any_skip_relocation, el_capitan:     "77720ca90705c26a92248cd822d4a3b0cef329c5b16e2da62a7815cfd61f0ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6668d38416f11e79a39db7a65ce6bc60bce14db6962ca7c06c104c2b69d456"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
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
