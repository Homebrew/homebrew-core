class DockerMachineDriverXhyve < Formula
  desc "Docker Machine driver for xhyve"
  homepage "https://github.com/zchee/docker-machine-driver-xhyve"
  url "https://github.com/zchee/docker-machine-driver-xhyve.git",
    :tag => "v0.2.3",
    :revision => "45426155af2998e9cf8a5eca12158fcf4d1acfd3"

  head "https://github.com/zchee/docker-machine-driver-xhyve.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f39a05dcffec9b4c0432b80ed257af219fc2170729d263d7e4896f588dfc7d6b" => :sierra
    sha256 "0c9254d6b999a82bd47939f72d4f270b934971351c8bf745a4e12b6900108c1d" => :el_capitan
    sha256 "dd8efbfed1d526d159355ed06273540c4e4db0ce3e683e475b7985efaf3e5084" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "go" => :build
  depends_on "docker-machine" => :recommended

  def install
    (buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve").install Dir["{*,.git,.gitignore,.gitmodules}"]

    ENV["GOPATH"] = "#{buildpath}/gopath"
    build_root = buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve"
    cd build_root do
      if build.head?
        git_hash = `git rev-parse --short HEAD --quiet`.chomp
        git_hash = "HEAD-#{git_hash}"
      end
      ENV["CGO_LDFLAGS"] = "#{build_root}/vendor/build/lib9p/lib9p.a -L#{build_root}/vendor/lib9p"
      ENV["CGO_CFLAGS"] = "-I#{build_root}/vendor/lib9p"
      system "make", "lib9p"
      system "go", "build", "-tags", "lib9p", "-x", "-o", bin/"docker-machine-driver-xhyve",
      "-ldflags",
      "'-w -s'",
      "-ldflags",
      "-X 'github.com/zchee/docker-machine-driver-xhyve/xhyve.GitCommit=Homebrew#{git_hash}'",
      "./main.go"
    end
  end

  def caveats; <<-EOS.undent
    This driver requires superuser privileges to access the hypervisor. To
    enable, execute
        sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
        sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
    EOS
  end

  test do
    assert_match "xhyve-memory-size",
    shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver xhyve -h")
  end
end
