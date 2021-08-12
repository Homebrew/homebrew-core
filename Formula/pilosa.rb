class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v1.4.1.tar.gz"
  sha256 "a250dda8788fefdb0b0b7eeff1bb44375a570cd4c6a0c501bc55612775b1578e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:     "703ee800aa37986fb22892672ae4f20020561df1aeccf60bc68f4f2c5807ec02"
    sha256 cellar: :any_skip_relocation, mojave:       "486ace10d0957669478591911549112c22d812b26a746b3aca8cf00fee726fc8"
    sha256 cellar: :any_skip_relocation, high_sierra:  "f7cd715d06c813bf358b3151ddfe24c4a7664b464b3d7bd047b222189d603281"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "776da185052f34aa5c973e92bfefb27304168a7d24f5cbb1dd1a951e1330cd5e"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/pilosa/pilosa").install buildpath.children
    cd "src/github.com/pilosa/pilosa" do
      system "make", "build", "FLAGS=-o #{bin}/pilosa", "VERSION=v#{version}"
      prefix.install_metafiles
    end
  end

  service do
    run [opt_bin/"pilosa", "server"]
    keep_alive true
    working_dir var
  end

  test do
    server = fork do
      exec "#{bin}/pilosa", "server"
    end
    sleep 0.5
    assert_match("Welcome. Pilosa is running.", shell_output("curl localhost:10101"))
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
