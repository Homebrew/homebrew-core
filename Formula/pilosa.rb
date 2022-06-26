class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v1.4.1.tar.gz"
  sha256 "a250dda8788fefdb0b0b7eeff1bb44375a570cd4c6a0c501bc55612775b1578e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "c24516ce6e3b184a1f85497be64e097f1a467602dcaac317564e4ff1254bd271"
    sha256 cellar: :any_skip_relocation, big_sur:      "05873e34a40580f73c31890f85b768e28a928383839f1bbd47ef7880273e3db4"
    sha256 cellar: :any_skip_relocation, catalina:     "703ee800aa37986fb22892672ae4f20020561df1aeccf60bc68f4f2c5807ec02"
    sha256 cellar: :any_skip_relocation, mojave:       "486ace10d0957669478591911549112c22d812b26a746b3aca8cf00fee726fc8"
    sha256 cellar: :any_skip_relocation, high_sierra:  "f7cd715d06c813bf358b3151ddfe24c4a7664b464b3d7bd047b222189d603281"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "776da185052f34aa5c973e92bfefb27304168a7d24f5cbb1dd1a951e1330cd5e"
  end

  # https://github.com/pilosa/pilosa/issues/2149#issuecomment-993029527
  deprecate! date: "2021-12-14", because: :unmaintained

  depends_on "go" => :build

  def install
    # Fix compilation with Go 1.18 - see https://github.com/golang/go/issues/51706
    inreplace "go.mod",
              "golang.org/x/sys v0.0.0-20190429190828-d89cdac9e872",
              "golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a"

    (buildpath/"go.sum").append_lines <<~EOS
      golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a h1:dGzPydgVsqGcTRVwiLJ1jVbufYwmzD3LfVPLKsKg+0k=
      golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
    EOS

    system "make", "build", "FLAGS=-o #{bin}/pilosa", "VERSION=v#{version}"
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
