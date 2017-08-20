require "language/go"

class Minishift < Formula
  desc "Runs a single-node OpenShift cluster inside a VM"
  homepage "https://minishift.io/"
  url "https://github.com/minishift/minishift/archive/v1.2.0.tar.gz"
  sha256 "93f172811b6d0af8987c4dcc72f091032a65d882bf1e1d9094f76595cd3e138f"

  depends_on "go" => :build
  depends_on "glide" => :build

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    (buildpath/"src/github.com/minishift/minishift").install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/jteeuwen/go-bindata/go-bindata" do
      system "go", "install"
    end

    cd "src/github.com/minishift/minishift" do
      system "make"
      prefix.install_metafiles
    end

    bin.install "bin/minishift"
  end

  test do
    assert_equal "-- Installing default add-ons ... OK\nminishift v#{version}\n", shell_output("#{bin}/minishift version")
    assert_equal "Does Not Exist\n", shell_output("#{bin}/minishift status")
  end
end
