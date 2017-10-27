class Faktory < Formula
  desc "Takin' care of business, workin' overtime"
  homepage "https://github.com/contribsys/faktory"
  url "https://github.com/contribsys/faktory/archive/v0.5.0.tar.gz"
  sha256 "388eefa0834ff71803a3353db5ae336e73246e1ca2a5866c218e8172a253fceb"

  depends_on "rocksdb"
  depends_on "snappy"
  depends_on "dep" => :build
  depends_on "go" => :build

  resource "ego" do
    url "https://github.com/benbjohnson/ego/archive/c779759b6d1ac35c9cdfa2681a92c1f6c893a98b.tar.gz"
    sha256 "784d37d39236d86abd3d9513485440b341ac35328982fb1f2cb22d9c30036bcb"
  end

  resource "bindata" do
    url "https://github.com/jteeuwen/go-bindata/archive/v3.0.7.tar.gz"
    sha256 "77a7214479e5ce9004e4afa6d0eb8ce14289030fadc55a3444249ab1fe2c7980"
  end

  def install
    go_bin_path = "#{buildpath}/bin"
    ENV["CGO_CFLAGS"] = "-I#{Formula["rocksdb"].opt_include}"
    ENV["CGO_LDFLAGS"] = "-L#{Formula["rocksdb"].opt_lib}"
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/contribsys/faktory").install buildpath.children

    mkdir go_bin_path
    ENV.prepend_path "PATH", go_bin_path

    resource("ego").stage do |stage|
      (buildpath/"src/github.com/benbjohnson/ego").install Pathname("#{stage.staging.tmpdir}/ego-c779759b6d1ac35c9cdfa2681a92c1f6c893a98b").children
      cd "#{buildpath}/src/github.com/benbjohnson/ego" do
        system "go", "build", "-o", "#{go_bin_path}/ego", "./cmd/ego"
      end
    end

    resource("bindata").stage do |stage|
      (buildpath/"src/github.com/jteeuwen/go-bindata").install Pathname("#{stage.staging.tmpdir}/go-bindata-3.0.7").children
      cd "#{buildpath}/src/github.com/jteeuwen/go-bindata" do
        system "go", "build", "-o", "#{go_bin_path}/go-bindata", "./go-bindata"
      end
    end

    cd "src/github.com/contribsys/faktory" do
      system "dep", "ensure"
      system "go", "generate", "github.com/contribsys/faktory/webui"
      system "go", "build", "-o", bin/"faktory", "./cmd/daemon.go"
      system "go", "build", "-o", bin/"faktory-cli", "./cmd/repl.go"
      prefix.install_metafiles
    end
  end

  test do
    shell_output("#{bin}/faktory -v", 0)
    shell_output("#{bin}/faktory-cli -v", 0)
  end
end
